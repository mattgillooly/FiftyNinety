class SongsController < ApplicationController

  # GET /songs
  def index
    @songs = Song.all
  end

end
