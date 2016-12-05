class CalendarsController < ApplicationController
  def index
    google_auth = GoogleCalendar.new(request: request)
    @calendars = google_auth.calendars
  end

  def show
    google_auth = GoogleCalendar.new(request: request, calendar_id: params[:id])
    @calendar = google_auth.calendar_for_today
  end
end
