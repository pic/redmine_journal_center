module JournalNotesHelper
  include QueriesHelper

  def current_user_notes?
    User.current == @request_user
  end
  def jcolumn_content(column, object)
    case column.name
      when :journal_subject then
        opts = {}
        opts[:onclick] = "$('#{dom_id object}').removeClassName('not-read')" if current_user_notes?
        link_to(h(object.journal_subject),
          {
            :controller => 'journal_notes',
            :action => 'show', :id => object
          },
          opts
        )
      when :spent_hours, :estimated_hours then
        value = column.value(object)
        "%.2f" % value.to_f
    else column_content(column, object)
    end
  end
end