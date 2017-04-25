class OauthController < ApplicationController
  def authorize
    @google_auth = GoogleCalendar.new(request: request)

    if @google_auth.authorized?
      redirect_to calendars_path
    else
      redirect_to @google_auth.authorization_url(callback: callback_url)
    end
  end

  def callback
    @google_auth = GoogleCalendar.new(request: request)
    @google_auth.handle_auth_callback!
    redirect_to calendars_path
  end

  def sign_out
    Google::Auth::Stores::RedisTokenStore.new(redis: $redis).delete(GoogleCalendar::USER_ID)
    redirect_to calendars_path
  end
end
