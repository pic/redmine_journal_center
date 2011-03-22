module JournalNotesHelper
  include QueriesHelper

  def jcolumn_content(column, object)
    case column.name
      when :journal_subject then
        link_to(h(object.journal_subject),
          {
            :controller => 'journal_notes',
            :action => 'show', :id => object
          },
          :onclick => "$('#{dom_id object}').removeClassName('not-read')"
        )
    else column_content(column, object)
    end
        #  :anchor => "change-#{object.id}"
  end
end