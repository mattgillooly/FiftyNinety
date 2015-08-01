module ApplicationHelper

  def nav_link_to(title, target)
    options = (title == @current_page_title) ? {class: 'active'} : {}
    content_tag(:li, options) do
      link_to title, target
    end
  end

end
