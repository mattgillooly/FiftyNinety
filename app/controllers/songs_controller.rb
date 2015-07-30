class SongsController < ApplicationController

  # GET /songs
  def index
    @songs = Song.order('remote_id desc').all

    respond_to do |format|
      format.html # index.html.erb
      format.xml do
        podcast = Podcast.new(@songs) do |channel|
          channel.title = 'NiftyFinety: All 50/90 Demos'
          channel.description = 'A podcast of all downloadable 50/90 demos, updated hourly.'
          channel.link = 'http://niftyfinety.com'
        end

        render :xml => podcast.to_rss
      end
    end
  end

end
