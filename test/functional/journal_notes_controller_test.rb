require File.join(File.dirname(__FILE__), '..', 'test_helper')

require 'project' unless defined?(Project)
class Project
  def allowed_actions
    ['journal_notes/index']
  end
end

class JournalNotesControllerTest < ActionController::TestCase

  fixtures :all

  def setup
    journal = Journal.find 1
    @user = journal.user
    @project = journal.journalized.project
    @request.session[:user_id] = @user.id

    # mark two journal note set for user 7
    journal.journalized.journals.first(2).each do |jo|
      JournalNote.create(:journal => jo, :user_id => 7, :deleted => true)
    end
  end

  test 'retrieve journals' do
    get :index, :project_id => @project.id
    assert_response :success
    journals = assigns['journals']
    assert_kind_of(Array, journals)
    assert_equal 3, journals.size
  end

  test 'retrieve journals but no self notified' do
    @user.pref.others[:no_self_notified] = true
    @user.pref.save!

    
    get :index, :project_id => @project.id
    assert_response :success
    journals = assigns['journals']
    assert_kind_of(Array, journals)
    assert_equal 2, journals.size
  end

  test 'retrieve other user journals but no self notified' do
    get :index, :project_id => @project.id, :user_id => 7
    assert_response :success
    journals = assigns['journals']
    assert_kind_of(Array, journals)
    assert_equal 1, journals.size
  end


end
