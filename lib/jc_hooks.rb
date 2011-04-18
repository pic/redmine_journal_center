
class JcenterHooks  < Redmine::Hook::ViewListener
  def vods_with_css(context)
    context[:controller].send :render_to_string, :partial => 'journal_notes/vods_with_css'
  end
  def view_projects_show_sidebar_bottom(context)
    vods_with_css(context)
  end
  def view_issues_sidebar_planning_bottom(context)
    vods_with_css(context)
  end
  def view_issues_show_details_bottom(context)
    %Q{
    <tr><td colspan="2">
    #{context[:controller].send :render_to_string, :partial => 'issues/jc_history'}
    </td></tr>
    }
  end
  #def view_issues_show_description_bottom(context)
  #  context[:controller].send :render_to_string, :partial => 'issues/jc_history'
  #end
  def view_layouts_base_html_head(context)
    stylesheet_link_tag 'journal_center', :plugin => 'redmine_journal_center' if ActivitiesController === context[:controller]
  end
  def view_layouts_base_sidebar(context)
    context[:controller].send :render_to_string, :partial => 'journal_notes/vods' if ActivitiesController === context[:controller]
  end
end
