Rails.application.routes.draw do
  scope "oauth" do
    get "authorize", to: "oauth#authorize"
    get "callback", to: "oauth#callback"
  end

  resource "calendar"

  root to: "calendars#show"
end
