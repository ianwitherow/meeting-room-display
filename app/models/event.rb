class Event
  attr_accessor :summary
  attr_accessor :begin_time
  attr_accessor :end_time
  attr_accessor :attendees

  def initialize(json)
    @summary = json.summary
    @begin_time = json.start.date_time
    @end_time = json.end.date_time
    @attendees = json.attendees.reject(&:resource).map { |attendee| attendee.display_name.presence || attendee.email }
  end
end