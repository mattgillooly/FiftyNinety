task :fetch_skirmishes => :environment do
  require 'scrapers/forum_scraper'
  require 'skirmish_parser'

  SKIRMISHES_URL = 'http://fiftyninety.fawmers.org/forums/song-skirmishes'
  scraper = Scrapers::ForumScraper::TopicIterator.new(SKIRMISHES_URL)

  parser = SkirmishParser::Parser.new

  scraper.each do |topic|
    if s = ::Skirmish.find_by(remote_url: topic.remote_url)
      s.update_attributes!(
        title: topic.title,
        starts_at: parser.parse(topic.title),
      )
    else
      Skirmish.create!(
        remote_url: topic.remote_url,
        title: topic.title,
        starts_at: parser.parse(topic.title),
      )
    end
  end
end
