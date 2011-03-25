require_dependency 'journal'

class JournalNote < ActiveRecord::Base

  belongs_to :journal
  belongs_to :user
  
  #validates_uniqueness_of :journal, :scope => :user_id

  def css_classes
    css_classes = []
    css_classes << 'not-read' unless read
    css_classes << 'important' if important
    css_classes.join(' ')
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
    "#{journalized.subject} / Update #{stored_indice!}"
  end

  def stored_indice!
    if stored_indice.nil?
      update_attribute(
        :stored_indice,
        journalized.journals(:order => 'created_on asc').index(self) + 1
        )
    end
    stored_indice
  end
end