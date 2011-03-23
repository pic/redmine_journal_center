ActionController::Routing::Routes.draw do |map|
  map.resources :journal_notes, :path_prefix => '/projects/:project_id', :member => {:toggle_important => :put}
end
