require_dependency 'journal_note'
require_dependency 'query'

class JournalNotesController < ApplicationController
  unloadable
  
  before_filter :find_project_by_project_id, :authorize
  before_filter :find_journal_and_note, :only => [:show, :destroy, :toggle_important]
  before_filter :find_user
  #before_filter :find_customers, :only => [:list, :select]

  helper :sort#, :issues

  def index
    user = @request_user || User.current
    not_self_condition = if user == User.current and user.pref.others[:no_self_notified]
      " and journals.user_id != #{user.id}"
    else
      ''
    end

    opts = {
      :joins => "join issues on journals.journalized_id = issues.id and journals.journalized_type = \'Issue\' left join journal_notes as jn1 on journals.id = jn1.journal_id and jn1.user_id = #{user.id}",
      :conditions => [%Q{issues.project_id = ? and 
(jn1.user_id is null or jn1.deleted = ?)#{not_self_condition}},
        @project, false]
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
    #  :conditions => ['journals.id in (?) and journal_notes.user_id =', fr.map(&:id), user],
    #  :order => 'journals.created_on desc'
    #  )
  end

  def show
    @note.update_attribute(:read, true)
    redirect_to :controller => 'issues', :action => 'show', 
      :id => @journal.journalized, :anchor => "change-#{@journal.id}"
  end
  
  def toggle_important
    important = !@note.important
    @note.update_attribute(:important, important)
    @note.update_attribute(:read, true) if params[:read]
    @note.update_attribute(:deleted, false) if important
    head :no_content
  end

  def destroy
    @note.update_attribute(:deleted, true)
    head :no_content
  end

  private
    def find_journal_and_note
      @journal = Journal.find params[:id]
      @note = @journal.user_journal_note || @journal.journal_notes.create!(:user => User.current)
    end
    def find_user
      @request_user = User.find_by_id params[:user_id] || User.current
    end

end
