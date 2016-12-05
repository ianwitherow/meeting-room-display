require "google/apis/calendar_v3"

class GoogleCalendar
  attr_reader :calendar

  def initialize(request:)
    @request = request
    @calendar = Google::Apis::CalendarV3::CalendarService.new
    @calendar.authorization = credentials
  end

  def calendar_for_today
    time_min = DateTime.now.beginning_of_day.rfc3339
    time_max = DateTime.now.end_of_day.rfc3339

    events = @calendar.list_events(
        calendar_id,
        order_by: "starttime",
        single_events: true,
        time_min: time_min,
        time_max: time_max)
    Calendar.new(events)
  end

  def handle_auth_callback!
    authorizer.handle_auth_callback(user_id, @request)
  end

  def authorized?
    @credentials.present?
  end

  def authorization_url(callback: )
    authorizer.get_authorization_url(request: @request, redirect_to: callback)
  end

  private

  def credentials
    @credentials ||= authorizer.get_credentials(user_id, @request)
  end

  def user_id
    "default"
  end

  def scope
    "https://www.googleapis.com/auth/calendar"
  end

  def token_store
    Google::Auth::Stores::FileTokenStore.new(file: config_store_file)
  end

  def config_store_file
    Rails.root.join("config", "google", "config.json")
  end

  def credentials_store_file
    Rails.root.join("config", "google", "calendar-oauth2.json")
  end

  def client_id
    Google::Auth::ClientId.from_file(credentials_store_file)
  end

  def authorizer
    Google::Auth::WebUserAuthorizer.new(client_id, scope, token_store, "/oauth/callback")
  end

  def calendar_id
    "ultimaker.com_33313636373633363835@resource.calendar.google.com"
  end
end
