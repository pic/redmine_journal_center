module ApplicationHelper
  def simple_pagination_links_full(paginator, count=nil, options={})
    page_param = options.delete(:page_param) || :page
    per_page_links = options.delete(:per_page_links)
    url_param = params.dup
    # don't reuse query params if filters are present
    url_param.merge!(:fields => nil, :values => nil, :operators => nil) if url_param.delete(:set_filter)

    html = ''
    if paginator.current.previous
      html << link_to('&#171; ' + l(:label_previous), url_param.merge(page_param => paginator.current.previous)) + ' '
    end

    html << (pagination_links_each(paginator, options) do |n|
      link_to(n.to_s, url_param.merge(page_param => n))
    end || '')

    if paginator.current.next
      html << ' ' + link_to((l(:label_next) + ' &#187;'), url_param.merge(page_param => paginator.current.next))
    end

    unless count.nil?
      html << " (#{paginator.current.first_item}-#{paginator.current.last_item}/#{count})"
      if per_page_links != false && links = per_page_links(paginator.items_per_page)
	      html << " | #{links}"
      end
    end

    html
  end
end