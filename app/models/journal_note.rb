require_dependency 'journal'

class JournalNote < ActiveRecord::Base

end

class Journal
  has_many :journal_notes
  def user_journal_note(user = User.current)
    journal_notes.find(:first, :conditions => {:user => user})
  end

  def journal_subject
    "#{journalized.subject} / Update #{id}"
  end
end