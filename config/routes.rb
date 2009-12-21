ActionController::Routing::Routes.draw do |map|
  map.resources :applicants
  map.root :controller => 'applicants', :action => 'index'
end
