require 'treetop'
require 'active_support/time_with_zone'
Treetop.load 'skirmish_grammar'

module SkirmishParser
  module Title
    def content
      elements.map{ |e| e.content }
    end

    def time
      # TODO: validate that only 1 date appears, and it matches weekday
      date = elements.select{ |e| :date == e.content.first }.first
      current_year = ::Date.today.year

      # TODO: validate that all times agree after timezone is applied
      if twz = elements.select{ |e| :time_with_zone == e.content.first }.first
        time_zone = twz.time_zone
        time_zone.local(current_year, date.month_num, date.day, twz.hour, twz.minute, 0)
      end
    end
  end

  module Word
    def content
      [:word, text_value]
    end
  end

  module Space
    def content
      [:space]
    end
  end

  module Punctuation
    def content
      [:punctuation]
    end
  end

  module Weekday
    def content
      [:weekday, text_value]
    end
  end

  module Month
    def content
      [:month, text_value]
    end
  end

  module Timezone
    def content
      [:timezone, text_value]
    end
  end

  module Time
    def content
      [:time, text_value]
    end
  end

  module TimeWithZone
    def content
      [:time_with_zone, text_value]
    end

    def time_zone
      tz = elements.detect{|a| :timezone == a.content.first}

      zone = case tz.text_value
             when 'est', 'et', 'edt'
               ActiveSupport::TimeZone['Eastern Time (US & Canada)']
             when'gmt'
               ActiveSupport::TimeZone['London']
             else
               ActiveSupport::TimeZone[tz.text_value]
             end

      raise "missing zone: #{tz.text_value}" unless zone
      zone
    end

    def pm?
      text_value.downcase.include?('pm')
    end

    def hour
      h = text_value.split(':')[0].to_i
      pm? ? h + 12 : h
    end

    def minute
      text_value.split(':')[1].to_i
    end
  end

  module Number
    def content
      [:number, text_value]
    end
  end

  module Date
    def content
      [:date, text_value]
    end

    def month_num
      ::Date::MONTHNAMES.index(text_value.split.first.capitalize)
    end

    def day
      text_value.split[1].to_i
    end
  end

  class Parser
    def parse(s)
      parser = SkirmishGrammarParser.new
      parser.parse(s.downcase.gsub(/[,;]+/, '')).time
    end
  end
end

