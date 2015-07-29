require 'open-uri'
require 'nokogiri'

module Scrapers
  module DemoScraper

    def self.scrape(song_id)
      url = "http://fiftyninety.fawmers.org/song/#{song_id}"
      html_doc = Nokogiri::HTML(open(url).read)
      Song.build(html_doc)
    end

    class Song < Struct.new(:demo_href, :posted_date)
      def self.build(html_doc)
        date_posted_el = html_doc.at_css('section.field-name-post-date div.field-item')

        new(
          html_doc.at_css('div.ui360 a')['href'],
          DateTime.strptime(date_posted_el.text, "%m/%d/%Y - %H:%M")
        )
      end
    end

  end
end
