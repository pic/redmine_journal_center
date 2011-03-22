require_dependency 'journal'

class JournalNote < ActiveRecord::Base

  belongs_to :journal
  belongs_to :user
  
  #validates_uniqueness_of :journal, :scope => :user_id

  def css_classes
    read ? '' : 'not-read'
  end
end

class Journal
  has_many :journal_notes
  
  def user_journal_note(user = User.current)
    journal_notes.find(:first, :conditions => {:user_id => user})
  end
  def safe_user_journal_note(user = User.current)
    user_journal_note(user = User.current) or
    JournalNote.new(:user => user)
  end

  def journal_subject
    "#{journalized.subject} / Update #{nindex}"
  end

  def nindex ; id ; end
end