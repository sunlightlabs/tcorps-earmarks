ActionController::Routing::Routes.draw do |map|
  map.resources :documents
  map.root :controller => 'documents', :action => 'index'
end