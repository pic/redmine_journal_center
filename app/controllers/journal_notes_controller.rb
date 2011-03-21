require_dependency 'journal_note'
class JournalNotesController < ApplicationController
  unloadable
  
  before_filter :find_project_by_project_id, :authorize
  #before_filter :find_customer, :only => [:edit, :update, :destroy]
  #before_filter :find_customers, :only => [:list, :select]

  helper :sort, :queries#, :issues

  def index
    opts = {
      :joins => 'join issues on journals.journalized_id = issues.id and journals.journalized_type = \'Issue\' left join journal_notes on journals.id = journal_notes.journal_id',
      :conditions => ['issues.project_id = ? and (journal_notes.user_id is null or (journal_notes.user_id = ? and journal_notes.deleted = ?))', @project, User.current, false]
      }
    @n_count = Journal.count(opts)
    @limit = per_page_option
    @journal_pages = Paginator.new self, @n_count, @limit, params['page']
    @offset = @journal_pages.current.offset
    fr = Journal.find(:all, opts.merge(
        :offset => @offset,
        :limit => @limit,
        :order => 'created_on desc'
    ))
    @journals = Journal.find(:all,
      :include => {:journalized => [:assigned_to, :tracker, :priority, :category, :fixed_version]},
      :conditions => ['journals.id in (?)', fr.map(&:id)],
      :order => 'created_on desc'
    )
    #@jnotes = JournalNote.find(:all,
    #  :include => {:journal => {:journalized => [:assigned_to, :tracker, :priority, :category, :fixed_version]}},
    #  :conditions => ['journals.id in (?) and journal_notes.user_id =', fr.map(&:id), User.current],
    #  :order => 'journals.created_on desc'
    #  )
  end

end
