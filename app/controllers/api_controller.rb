class ApiController < ApplicationController
  before_action :load_google_calendar

  def calendars
    render json: @google_calendar.calendars.map(&:as_json)
  end

  def calendar
    render json: @google_calendar.calendar_for_today(params[:id]).as_json
  end

  private

  def load_google_calendar
    @google_calendar = GoogleCalendar.new(request: request)
  end
end
