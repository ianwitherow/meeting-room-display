class Calendar
  include ActionView::Helpers::DateHelper
  attr_accessor :calendar_id
  attr_accessor :location
  attr_accessor :google_events
  attr_writer :events

  def initialize(calendar_data, calendar_service = nil)
    @location = parse_location(calendar_data.try(:summary))
    @calendar_id = calendar_data.try(:id)
    @calendar_service = calendar_service
  end

  def events
    @events ||= @calendar_service.list_events(
        @calendar_id,
        order_by: "starttime",
        single_events: true,
        time_min: DateTime.now.beginning_of_day.rfc3339,
        time_max: DateTime.now.end_of_day.rfc3339).items.map { |item| Event.new(self, item) }
  end

  def as_json
    calendar_json = {name: location, calendar_id: calendar_id}
    calendar_json[:events] = events.map(&:as_json) if events.present?
    calendar_json
  end

  def add_event(calendar_id, event)
    @cal_result = @calendar_service.insert_event(calendar_id, event)
  end

  def description
    if in_use?
      "This room is used by #{current_event.organizer} " \
        "until #{current_event.end_time.strftime("%l:%M %P")}."
    else
      "This room is available"
    end
  end

  def time_left(suffix: "")
    if in_use?
      if current_event.all_day?
        "this meeting takes all day"
      else
        distance_of_time_in_words(Time.zone.now, current_event.end_time) + suffix
      end
    else
      if next_event.present?
        distance_of_time_in_words(Time.zone.now, next_event.begin_time) + suffix
      else
        ""
      end
    end
  end

  def next_event
    events
        .reject(&:rejected)
        .sort_by(&:begin_time)
        .detect { |event| event.begin_time > Time.zone.now }
  end

  def after_event(next_event)
    events
        .reject(&:rejected)
        .sort_by(&:begin_time)
        .detect { |event| event.begin_time > next_event.begin_time  }
  end

  def available?
    current_event.nil?
  end

  def in_use?
    !available?
  end

  def current_event
    events.detect do |event|
      next if event.rejected

      event.all_day? ||
          Time.zone.now >= event.begin_time && Time.zone.now <= event.end_time
    end
  end

  private

  def parse_location(location)
    return '' if location.blank?
    location.gsub(/\s*\(.*\)/, "")
  end
end
