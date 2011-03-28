ActionController::Routing::Routes.draw do |map|
  map.resources :journal_notes, :path_prefix => '/user/:user_id/projects/:project_id', :member => {:toggle_important => :put}
  map.resources :journal_notes, :path_prefix => '/projects/:project_id', :member => {:toggle_important => :put}
end
