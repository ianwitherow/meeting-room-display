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
end
