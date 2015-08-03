require 'open-uri'
require 'nokogiri'

module Scrapers
  module ForumScraper

    class Topic < Struct.new(:remote_url, :title, :comment_count, :last_commenter, :updated_at)
      def self.build(el)
        new(
          el.at_css('td.views-field-title a')['href'],
          el.at_css('td.views-field-title a').text.strip,
          el.at_css('td.views-field-comment-count').text.to_i,
          el.at_css('td.views-field-last-updated a').text,
          el.at_css('td.views-field-last-updated em').text
        )
      end
    end

    class TopicsListPage
      def initialize(url)
        @url = url
        @html_doc = Nokogiri::HTML(open(url).read)
      end

      def topics
        table_rows = @html_doc.xpath('//tbody/tr')
        table_rows.map { |table_row| Topic.build(table_row) }
      end

      def next_page
        # Note: The last page has no "Next" link.
        next_link = @html_doc.at_css('li.pager-next a')
        self.class.new(URI.join(@url, next_link['href'])) if next_link
      end
    end

    class TopicsListPageIterator < Enumerator
      #START_URL = 'http://fiftyninety.fawmers.org/forums/song-skirmishes'
      #START_URL = 'http://fiftyninety.fawmers.org/forum/1'

      def initialize(start_url)
        page = TopicsListPage.new(start_url)
        super() do |yielder|
          yielder << page
          while page = page.next_page
            yielder << page
          end
        end
      end
    end

    class TopicIterator < Enumerator
      def initialize(start_url)
        topics_list_page_iterator = TopicsListPageIterator.new(start_url)
        super() do |yielder|
          topics_list_page_iterator.lazy.each do |page|
            page.topics.each do |topic|
              yielder << topic
            end
          end
        end
      end
    end

  end
end

