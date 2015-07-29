module ApplicationHelper

  def link_to_remote_user(username, user_href)
    link_to(username, URI.join('http://fiftyninety.fawmers.org/', user_href).to_s)
  end

  def link_to_remote_song(title, remote_id)
    link_to(title, URI.join('http://fiftyninety.fawmers.org/song/', remote_id.to_s).to_s)
  end

end
