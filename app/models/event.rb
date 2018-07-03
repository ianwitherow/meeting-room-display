class Event
  attr_accessor :calendar
  attr_accessor :summary
  attr_accessor :begin_time
  attr_accessor :end_time
  attr_accessor :attendees
  attr_accessor :organizer
  attr_accessor :rejected
  attr_accessor :all_day
  attr_accessor :welcome
  attr_accessor :check_event
  attr_accessor :next_event
  attr_accessor :meeting_event

  def initialize(calendar, json)
    @calendar = calendar
    if json.present?
      @summary = json.summary
      @all_day = json.start.date_time.blank?
      @begin_time = parse_begin_time(json.start.date_time)
      @end_time = parse_end_time(json.end.date_time)
      @attendees = parse_attendees(json.attendees)
      @organizer = parse_attendee(json.organizer)
      @rejected = parse_rejected(json.attendees)
      @welcome = parse_welcome(json.summary)
      @check_event = parse_check_event(json.summary)
      @next_event = parse_next_event(json.summary)
      @meeting_event = parse_meeting_event(json.summary)
    end
  end

  def as_json
    {
      summary: summary,
      begin_time: begin_time,
      end_time: end_time,
      attendees: attendees,
      rejected: rejected,
      all_day: all_day,
      welcome: summary,
      check_event: summary,
      next_event: summary,
      meeting_event: summary
    }
  end

  def all_day?
    @all_day
  end

  def duration
    end_time.to_i - begin_time.to_i
  end

  def overlapping?
    calendar.events.any? do |event|
      next if event == self

      (event.begin_time <= begin_time && event.end_time > begin_time) ||
        (event.begin_time < end_time && event.end_time >= end_time)
    end
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
      parse_attendee(attendee)
    end
  end

  def parse_attendee(attendee)
    return '' if attendee.blank?

    name = attendee.display_name.presence || attendee.email
    name.gsub!("@ultimaker.com", "")

    if name =~ /\A\w\.\w+\z/
      name = name.split(".").map(&:capitalize).join(". ")
    end

    name
  end

  def parse_rejected(attendees)
    return false if attendees.blank?

    attendees.detect(&:resource).try(:response_status) != "accepted"
  end

  def parse_welcome(summary)
    return '' if summary.blank?
    summary[/(?<=\[).+?(?=\])/]
  end

  def parse_check_event(summary)
     if summary.include?("[") == false
      return ''
  else
    return 'is currently in a meeting. '
    end
  end

  def parse_next_event(summary)
     if summary.include?("[") == false
      return ''
  else
    return 'Welcome '
    end
  end

  def parse_meeting_event(summary)
    if summary.include?("[") == false
      return 'Next opening is at'
    else
      return ', next opening is at'
    end
  end
end
