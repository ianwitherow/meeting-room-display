Rails.application.routes.draw do
  scope "oauth" do
    get "authorize", to: "oauth#authorize"
    get "callback", to: "oauth#callback"
  end

  resources :calendars, constraints: { id: /[0-z\.]+/ }

  root to: "calendars#index"
end
