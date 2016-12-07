class Event
  attr_accessor :calendar
  attr_accessor :summary
  attr_accessor :begin_time
  attr_accessor :end_time
  attr_accessor :attendees
  attr_accessor :rejected
  attr_accessor :all_day

  def initialize(calendar, json)
    @calendar = calendar
    if json.present?
      @summary = json.summary
      @all_day = json.start.date_time.blank?
      @begin_time = parse_begin_time(json.start.date_time)
      @end_time = parse_end_time(json.end.date_time)
      @attendees = parse_attendees(json.attendees)
      @rejected = parse_rejected(json.attendees)
    end
  end

  def as_json
    {
      key: self.object_id,
      begin_time: I18n.l(begin_time, format: :time_only),
      duration: duration,
      end_time: I18n.l(end_time, format: :time_only),
      is_overlapping: overlapping?,
      is_rejected: rejected,
      is_consecutive: consecutive?,
      seconds_after_midnight: seconds_after_midnight,
      summary: summary
    }
  end

  def all_day?
    @all_day
  end

  def duration
    end_time.to_i - begin_time.to_i
  end

  def seconds_after_midnight
    begin_time.seconds_since_midnight
  end

  def overlapping?
    calendar.events.any? do |event|
      next if event == self

      (event.begin_time <= begin_time && event.end_time > begin_time) ||
        (event.begin_time < end_time && event.end_time >= end_time)
    end
  end

  def consecutive?
    calendar.events
            .reject { |event| event == self || event.rejected }
            .sort_by(&:begin_time)
            .any? { |event| begin_time == event.end_time }
  end

  private

  def parse_begin_time(begin_time)
    begin_time.presence || Date.current.beginning_of_day + 8.hours
  end

  def parse_end_time(end_time)
    end_time.presence || Date.current.end_of_day - 6.hours
  end

  def parse_attendees(attendees)
    return [] if attendees.blank?

    attendees.reject(&:resource).find_all do |attendee|
      attendee.response_status == "accepted"
    end.map do |attendee|
      attendee.display_name.presence || attendee.email
    end
  end

  def parse_rejected(attendees)
    return false if attendees.blank?

    attendees.detect(&:resource).response_status != "accepted"
  end
end
