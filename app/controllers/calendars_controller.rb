class CalendarsController < ApplicationController
  def index
    google_auth = GoogleCalendar.new(request: request)
    @calendars = google_auth.calendars
  end

  def show
    google_auth = GoogleCalendar.new(request: request)
    @calendar = google_auth.calendar_for_today(params[:id])
    @other_available_calenders = google_auth.available_calendars if @calendar.in_use?
   
  end

  def newevent
  	 google_auth = GoogleCalendar.new(request: request)
  	 @calendar = google_auth.calendar_for_today(params[:id])

  	 event = Google::Apis::CalendarV3::Event.new({
      'summary': 'Room Reserved 2',
      'location': '212 S. 14th Street, Baton Rouge, LA',
      'description': 'TSE impromptu meeting.',
      'start': {
        'date_time': '2018-06-25T08:00:00',
        'time_zone': 'America/Chicago',
      },
      'end': {
        'date_time': '2018-06-25T09:00:00',
        'time_zone': 'America/Chicago',
      },
      'attendees': [
        {'email': params[:id]},
      ],
    })

     @calendar.add_event(params[:id],event)
     redirect_to calendars_path
	end	
end
