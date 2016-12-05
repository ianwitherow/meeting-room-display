class CalendarsController < ApplicationController
  def show

    begin
      @google_auth = GoogleCalendar.new(request: request)
      render json: @google_auth.calendar_for_today
    rescue Google::Apis::ClientError
      redirect_to authorize_path
    end
  end
end
