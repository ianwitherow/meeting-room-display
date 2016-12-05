class Calendar
  attr_accessor :items
  attr_accessor :location

  def initialize(json = nil)
    if json.present?
      @location = json.summary
      @items = json.items.map { |item| Event.new(item) }
    end
  end

  def current_meeting
    @items.detect { |event| Time.zone.now >= event.begin_time && Time.zone.now <= event.end_time }
  end

  def time_left_in_current_meeting
    current_meeting.present? ? current_meeting.end_time - Time.zone.now : nil
  end
end
