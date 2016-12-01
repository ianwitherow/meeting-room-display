require "active_support/concern"

module GoogleAuthentication
  extend ActiveSupport::Concern

  private

  def client_id
    Google::Auth::ClientId.from_file(credentials_store_file)
  end

  def authorizer
    Google::Auth::WebUserAuthorizer.new(client_id, scope, token_store, "/oauth/callback")
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

  def user_id
    "default"
  end

  def credentials
    @credentials ||= authorizer.get_credentials(user_id, request)
  end
end
