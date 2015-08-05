module ApplicationHelper

  def nav_link_to(title, target)
    options = (title == @current_page_title) ? {class: 'active'} : {}
    content_tag(:li, options) do
      link_to title, target
    end
  end

  ZONES = {
    'EDT' => ActiveSupport::TimeZone["Eastern Time (US & Canada)"],
    'PDT' => ActiveSupport::TimeZone["Pacific Time (US & Canada)"],
    'GMT' => ActiveSupport::TimeZone["London"],
  }

  def skirmish_link(skirmish)
    t = skirmish.starts_at

    zoned = ZONES.map do |name, tz|
      h = tz.utc_to_local(t).hour
      "#{((h - 1) % 12) + 1}#{ (h > 11 && h < 24) ? 'PM' : 'AM'}&nbsp;#{name}"
    end.join(' / ').html_safe

    link_to zoned, skirmish.url
  end

end
