require 'google/apis/calendar_v3'

class CalendarsController < ApplicationController
  include GoogleAuthentication

  def show
    calendar.authorization = credentials
    time_min = DateTime.now.beginning_of_day.rfc3339
    time_max = DateTime.now.end_of_day.rfc3339

    feed = calendar.list_events(calendar_id, order_by: "starttime", single_events: true, time_min: time_min, time_max: time_max)

    render json: Calendar.new(feed)
  end

  private

  def calendar
    @calendar ||= Google::Apis::CalendarV3::CalendarService.new
  end

  def calendar_id
    "ultimaker.com_33313636373633363835@resource.calendar.google.com"
  end
end
