require 'scrapers'

task :fetch_all_demos => :environment do
  Scrapers::SonglistScraper::SongIterator.new.each do |song|
    scrape_song(song)
  end
end

task :fetch_all_soundcloud_demos => :environment do
  Scrapers::SonglistScraper::SongIterator.new.each do |song|
    if Song.where(remote_id: song.id).exists?
      puts "song:#{song.id}: Already scraped."
    elsif song.has_link
      puts "song:#{song.id}: Has streaming link."
      scrape_soundcloud_song(song)
    else
      puts "song:#{song.id}: Does not have a streaming link."
    end
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
    scrape_demo_song(song)
  elsif song.has_link
    puts "song:#{song.id}: Has streaming link."
    scrape_soundcloud_song(song)
  else
    puts "song:#{song.id}: Has no scrapable demo."
  end
end

def scrape_demo_song(song)
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
end

def scrape_soundcloud_song(song)
  demo = Scrapers::LinkScraper.scrape(song.id)

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

  puts "song:#{song.id}: Scraped streaming demo."
rescue => ex
  puts "song:#{song.id}: Error scraping streaming demo.  #{ex.message}"
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
