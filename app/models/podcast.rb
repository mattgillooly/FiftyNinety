require 'rss/2.0'
require 'rss/itunes'

class Podcast

  def initialize(songs)
    @songs = songs

    @rss = RSS::Rss.new( "2.0" )

    @channel = RSS::Rss::Channel.new
    @channel.language = 'en'

    yield @channel

    @rss.channel = @channel
  end

  def to_rss
    @songs.each do |song|
      item = RSS::Rss::Channel::Item.new
      item.title = "#{song.title} - #{song.username}"
      item.link = song.remote_url
      item.pubDate = song.posted_date.to_time
      item.description = [song.liner_notes, song.lyrics].compact.join("\n\n")

      item.enclosure = RSS::Rss::Channel::Item::Enclosure.new(song.demo_href, 0, 'audio/mpeg')
      @channel.items << item
    end

    @rss.to_s
  end

end
