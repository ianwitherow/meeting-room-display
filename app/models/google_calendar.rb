class GoogleCalendar
  USER_ID = "default".freeze
  SCOPE = "https://www.googleapis.com/auth/calendar".freeze

  attr_reader :calendar

  def initialize(request:)
    @request = request
    @calendar_service = Google::Apis::CalendarV3::CalendarService.new
    @calendar_service.authorization = credentials
  end

  def calendars
    @calendar_service.list_calendar_lists.items.map do |item|
      next unless item.id.ends_with?("resource.calendar.google.com")
      Calendar.new(item)
    end.compact.sort_by { |calendar| calendar.location }
  end

  def calendar(calendar_id)
    @calendar_service.get_calendar_list(calendar_id)
  end

  def calendar_for_today(calendar_id)
    time_min = DateTime.now.beginning_of_day.rfc3339
    time_max = DateTime.now.end_of_day.rfc3339

    events_data = @calendar_service.list_events(
      calendar_id,
      order_by: "starttime",
      single_events: true,
      time_min: time_min,
      time_max: time_max)

    calendar_data = calendar(calendar_id)
    Calendar.new(calendar_data, events_data)
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
