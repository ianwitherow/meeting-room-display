class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  http_basic_authenticate_with name: "ultimaker", password: "ultimaker2011"

  rescue_from Google::Apis::AuthorizationError, Google::Apis::ClientError do
    redirect_to authorize_url
  end
end
