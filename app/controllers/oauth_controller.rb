class OauthController < ApplicationController
  include GoogleAuthentication

  def authorize
    if credentials.nil?
      redirect_to authorizer.get_authorization_url(request: request, redirect_to: callback_url)
    else
      redirect_to calendar_path
    end
  end

  def callback
    authorizer.handle_auth_callback(user_id, request)
    redirect_to calendar_path
  end
end
