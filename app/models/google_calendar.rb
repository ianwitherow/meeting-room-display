class GoogleCalendar
  USER_ID = "default".freeze
  SCOPE = "https://www.googleapis.com/auth/calendar".freeze

  attr_reader :calendar

  def initialize(request:, calendar_id: nil)
    @request = request
    @calendar_id = calendar_id
    @calendar = Google::Apis::CalendarV3::CalendarService.new
    @calendar.authorization = credentials
  end

  def calendars
    @calendar.list_calendar_lists.items.map do |item|
      next unless item.id.ends_with?("resource.calendar.google.com")
      Calendar.new(item)
    end.compact.sort_by { |calendar| calendar.location }
  end

  def calendar_for_today
    time_min = DateTime.now.beginning_of_day.rfc3339
    time_max = DateTime.now.end_of_day.rfc3339

    events = @calendar.list_events(
        @calendar_id,
        order_by: "starttime",
        single_events: true,
        time_min: time_min,
        time_max: time_max)
    Calendar.new(events)
  end

  def handle_auth_callback!
    authorizer.handle_auth_callback(USER_ID, @request)
  end

  def authorized?
    @credentials.present?
  end

  def authorization_url(callback:)
    authorizer.get_authorization_url(request: @request, redirect_to: callback)
  end

  private

  def credentials
    @credentials ||= authorizer.get_credentials(USER_ID, @request)
  end

  def token_store
    Google::Auth::Stores::RedisTokenStore.new(redis: $redis)
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
    Google::Auth::WebUserAuthorizer.new(client_id, SCOPE, token_store, "/oauth/callback")
  end
end
