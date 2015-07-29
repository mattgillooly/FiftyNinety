require 'open-uri'
require 'nokogiri'

module Scrapers
  module SonglistScraper

    def self.songs_newer_than(threshold_id)
      iter = SongIterator.new

      # This takes advantage of songs' auto-incrementing IDs and sort-order of the list
      iter.take_while { |song| song.id > threshold_id }
    end

    class Song < Struct.new(:title, :href, :username, :user_href, :has_demo)
      def self.build(el)
        song_link = el.at_css('td.views-field-title a')
        user_link = el.at_css('td.views-field-name a')
        demo_img = el.at_css('img[alt="Demo"]')

        new(
          song_link.text,
          song_link['href'],
          user_link.text,
          user_link['href'],
          !!demo_img
        )
      end

      def id
        href.split('/').last.to_i
      end
    end

    class Page
      def initialize(url)
        @url = url
        @html_doc = Nokogiri::HTML(open(url).read)
      end

      def songs
        table_rows = @html_doc.xpath('//tbody/tr')
        table_rows.map { |table_row| Song.build(table_row) }
      end

      def next_page
        # Note: The last page has no "Next" link.
        next_link = @html_doc.xpath('//li[contains(@class, "pager-next")]/a').first
        self.class.new(URI.join(@url, next_link['href'])) if next_link
      end
    end

    class PageIterator < Enumerator
      # NOTE: This list includes songs with off-site demos, e.g. Soundcloud
      START_URL = 'http://fiftyninety.fawmers.org/demos'

      def initialize
        page = Page.new(START_URL)
        super() do |yielder|
          yielder << page
          while page = page.next_page
            yielder << page
          end
        end
      end
    end

    class SongIterator < Enumerator
      def initialize
        super() do |yielder|
          PageIterator.new.lazy.each do |page|
            page.songs.each do |song|
              yielder << song
            end
          end
        end
      end
    end

  end
end
