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

          # Album art for iTunes
          channel.image = RSS::Rss::Channel::Image.new
          channel.image.url = 'http://niftyfinety.com/assets/podcast_logo.png'
          channel.image.title = channel.title
          channel.image.link = channel.link
        end

        render :xml => podcast.to_rss
      end
    end
  end

end
