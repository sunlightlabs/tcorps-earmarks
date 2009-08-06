ActionController::Routing::Routes.draw do |map|
  map.resources :documents
  map.success '/success', :controller => 'documents', :action => 'success'
  map.root :controller => 'documents', :action => 'index'
end