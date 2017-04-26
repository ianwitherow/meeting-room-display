class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  http_basic_authenticate_with name: ENV["BASIC_AUTH_USER_NAME"], password: ENV["BASIC_AUTH_PASSWORD"]

  rescue_from Google::Apis::AuthorizationError, Google::Apis::ClientError do
    redirect_to authorize_url
  end
end
