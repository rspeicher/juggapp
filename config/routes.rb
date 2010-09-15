JuggApp::Application.routes.draw do
  resource :admin, :controller => 'admin', :only => [:show]

  resources :applications, :controller => :applicants, :except => [:show, :destroy] do
    post :post, :on => :member
  end

  resource :user_session, :only => [:new, :create, :destroy]

  match "/login" => "user_sessions#new"

  match "/logout" => "user_sessions#destroy", :method => :delete

  root :to => "applicants#index"
end
