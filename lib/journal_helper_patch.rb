require_dependency 'journals_helper'
require_dependency 'journal_note'

module JournalsHelper
  def render_notes(issue, journal, options={})
    content = ''
    editable = User.current.logged? && (User.current.allowed_to?(:edit_issue_notes, issue.project) || (journal.user == User.current && User.current.allowed_to?(:edit_own_issue_notes, issue.project)))
    links = []
    if !journal.notes.blank?
      links << link_to_remote(image_tag('comment.png'),
                              { :url => {:controller => 'journals', :action => 'new', :id => issue, :journal_id => journal} },
                              :title => l(:button_quote)) if options[:reply_links]
      links << link_to_in_place_notes_editor(image_tag('edit.png'), "journal-#{journal.id}-notes",
                                             { :controller => 'journals', :action => 'edit', :id => journal },
                                                :title => l(:button_edit)) if editable
      links << link_to_remote(
        image_tag(journal.safe_user_journal_note.important ? 'flag.png' : 'bullet.png',
          :plugin => 'redmine_journal_center'),
        {:url => {:controller => 'journal_notes', :action => 'toggle_important', :id => journal, :project_id => issue.project, :read => true}, :method => :put,
          :loading => "toggleImportantInIssue('#{dom_id journal, :toggle_important}')"},
        :id => dom_id(journal, :toggle_important)
      )
    end
    unless journal.safe_user_journal_note.deleted
      links << link_to_remote('X',
        {
          :url => {:controller => 'journal_notes', :action => 'destroy', :id => journal, :project_id => issue.project},
          :method => :delete,
          :loading => "$('#{dom_id journal, :delete_note}').hide()"
        },
        :id => dom_id(journal, :delete_note)
      )
    end
    content << content_tag('div', links.join(' '), :class => 'contextual') unless links.empty?
    content << textilizable(journal, :notes)
    css_classes = "wiki"
    css_classes << " editable" if editable
    content_tag('div', content, :id => "journal-#{journal.id}-notes", :class => css_classes)
  end

end