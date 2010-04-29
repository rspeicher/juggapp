ActionController::Routing::Routes.draw do |map|
  map.resource :admin, :controller => 'admin', :only => [:show]
  map.resources :applications, :controller => :applicants, :except => [:show, :destroy], :member => { :post => :post }

  map.resource :user_session, :only => [:new, :create, :destroy]
  map.connect '/login', :controller => 'user_sessions', :action => 'new'
  map.connect '/logout', :controller => 'user_sessions', :action => 'destroy'

  map.root :controller => 'applicants', :action => 'index'
end
