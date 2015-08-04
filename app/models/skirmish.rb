class Skirmish < ActiveRecord::Base

  def url
    "http://fiftyninety.fawmers.org/#{remote_url}"
  end

end
