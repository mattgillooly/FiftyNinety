require 'scrapers'

task :fetch_all_demos => :environment do
  Scrapers::SonglistScraper::SongIterator.new.each do |song|
    scrape_song(song)
  end
end

task :fetch_new_demos => :environment do
  max_remote_id = Song.maximum(:remote_id)
  puts "fetching songs newer than #{max_remote_id}"

  Scrapers::SonglistScraper.songs_newer_than(max_remote_id).each do |song|
    scrape_song(song)
  end
end

def scrape_song(song)
  if Song.where(remote_id: song.id).exists?
    puts "song:#{song.id}: Already scraped."
  elsif song.has_demo
    puts "song:#{song.id}: Scraping demo now."

    demo = Scrapers::DemoScraper.scrape(song.id)

    # TODO: Should fetch song titles from demo object, as full titles
    # appear on song page, but are truncated in list view.
    #
    ::Song.create!(
      remote_id: song.id,
      title: song.title,
      username: song.username,
      user_href: song.user_href,
      has_demo: song.has_demo,
      demo_href: demo.demo_href,
      posted_date: demo.posted_date,
      liner_notes: demo.liner_notes,
      lyrics: demo.lyrics,
    )
  else
    puts "song:#{song.id}: Has no scrapable demo."
  end
end


task :backfill_song_liner_notes_and_lyrics => :environment do
  Song.find_each do |song|
    puts "song:#{song.remote_id}: Backfilling liner_notes and lyrics"

    demo = Scrapers::DemoScraper.scrape(song.remote_id)

    song.update_attributes!(
      liner_notes: demo.liner_notes,
      lyrics: demo.lyrics,
    )
  end
end
