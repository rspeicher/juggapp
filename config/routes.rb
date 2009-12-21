ActionController::Routing::Routes.draw do |map|
  map.resources :applicant
  map.root :controller => 'applicants', :action => 'index'
end
