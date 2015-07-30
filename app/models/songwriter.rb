class Songwriter

  def initialize(handle)
    @handle = handle
  end

  def songs
    Song.where(user_href: "/user/#{handle}").order('posted_date DESC')
  end

end
