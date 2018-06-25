class JsonOnly
  def matches?(request)
    request.format == :json
  end
end

Rails.application.routes.draw do
  scope "oauth" do
    get "authorize", to: "oauth#authorize"
    get "callback", to: "oauth#callback"
    get "sign_out", to: "oauth#sign_out"
  end

  resources :calendars, constraints: { id: /[0-z\.]+/ }

  get "calendars/newevent/:id", to: "calendars#newevent", as: "addnewevent", constraints: { id: /[0-z\.]+/ }

  scope "api" do
    constraints format: :json do
      get "calendars", to: "api#calendars", as: :calendars_api
      get "calendars/:id", to: "api#calendar", as: :calendar_api, constraints: { id: /[0-z\.]+/ }
    end
  end

  root to: "calendars#index"
end
