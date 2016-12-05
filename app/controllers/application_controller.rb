class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from Google::Apis::AuthorizationError, Google::Apis::ClientError do
    redirect_to authorize_url
  end
end
