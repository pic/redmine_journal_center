require 'redmine'

#require 'journal_center_observer'

#ActiveRecord::Base.observers << JournalCenterObserver
#config.to_prepare do
#  unless config.action_controller.perform_caching
#    JournalCenterObserver.instance.reload_observer
#  end
#end

Redmine::Plugin.register :redmine_journal_center do
  name 'Redmin Journal Center'
  description 'This plugin adds a view where user can check journal updates like in an inbox'
  version '0.0.1'
  url 'http://github.com/pic/redmine_journal_center'
  author 'Nicola Piccinini'
  author_url 'mailto:piccinini@gmail.com'


  project_module(:jcenter_module) do
    permission :list_journal_notes, {:journal_notes => [:index]}
  end

  menu :project_menu, :journal_notes, {:controller => 'journal_notes', :action => 'index'}, 
    :param => :project_id, :caption => :jcenter_title

end
