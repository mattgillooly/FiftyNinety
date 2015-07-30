require 'open-uri'
require 'nokogiri'

module Scrapers
  module DemoScraper

    def self.scrape(song_id)
      url = "http://fiftyninety.fawmers.org/song/#{song_id}"
      html_doc = Nokogiri::HTML(open(url).read)
      Song.build(html_doc)
    end

    class Song < Struct.new(:demo_href, :posted_date, :liner_notes, :lyrics)
      def self.build(html_doc)
        date_posted_el = html_doc.at_css('section.field-name-post-date div.field-item')

        new(
          html_doc.at_css('div.ui360 a')['href'],
          DateTime.strptime(date_posted_el.text, "%m/%d/%Y - %H:%M"),
          text_in_section(html_doc, 'Liner Notes'),
          text_in_section(html_doc, 'Lyrics'),
        )
      end

      def self.text_in_section(html_doc, section_title)
        if section_header = html_doc.at_css("section h2[contains('Lyrics')]")
          section_header.parent.css('p').map(&:text).join("\n\n")
        end
      end
    end

  end
end
