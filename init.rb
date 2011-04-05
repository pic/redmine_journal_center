require 'redmine'

ActiveRecord::Base.observers << JournalCenterObserver
config.to_prepare do
  require_dependency 'journal_helper_patch'
  require_dependency 'hooks'
  unless config.action_controller.perform_caching
    JournalCenterObserver.instance.reload_observer
  end
end

Redmine::Plugin.register :redmine_journal_center do
  name 'Redmine Journal Center'
  description 'This plugin adds a view where user can check journal updates like in an inbox'
  version '0.0.1'
  url 'http://github.com/pic/redmine_journal_center'
  author 'Nicola Piccinini'
  author_url 'mailto:piccinini@gmail.com'

  project_module(:jcenter_module) do
    permission :list_journal_notes, {:journal_notes => [:index]}
    permission :read_journal_note, {:journal_notes => [:show]}
    permission :destroy_journal_note, {:journal_notes => [:destroy]}
    permission :toggle_important_journal_note, {:journal_notes => [:toggle_important]}
  end

  menu :project_menu, :journal_notes, {:controller => 'journal_notes', :action => 'index'}, 
    :param => :project_id, :caption => :jcenter_title

end
