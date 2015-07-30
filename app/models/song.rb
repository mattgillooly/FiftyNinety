require 'uri'

class Song < ActiveRecord::Base

  def remote_url
    URI.join('http://fiftyninety.fawmers.org/song/', remote_id.to_s).to_s
  end

  def remote_user_url
    URI.join('http://fiftyninety.fawmers.org/', user_href).to_s
  end

end
