class SongsController < ApplicationController

  # GET /songs
  def index
    @songs = Song.order('remote_id desc').all
  end

end
