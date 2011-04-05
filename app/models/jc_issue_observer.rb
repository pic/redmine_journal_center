class JcIssueObserver <  ActiveRecord::Observer
  observe :issue

  def after_create(issue)
    if JournalCenter.instance.add_journal_on_issue_creation?
      issue.journals.create! :user => User.current
    end
  end

  def reload_observer
    observed_classes.each do |klass|
      klass.name.constantize.add_observer(self)
    end
  end
  
end

