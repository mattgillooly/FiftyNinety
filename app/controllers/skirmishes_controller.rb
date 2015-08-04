class SkirmishesController < ApplicationController

  DEFAULT_ZONE = ActiveSupport::TimeZone["America/New_York"]

  # GET /skirmishes
  # GET /skirmishes.ics
  def index
    @current_page_title = 'Skirmishes'
    @skirmishes = Skirmish.all

    respond_to do |format|
      format.html do
        skirmishes_by_date = @skirmishes.select(&:starts_at).
          group_by{|s| s.starts_at.to_date}

        dates = Date.new(2015, 6, 28)..Date.new(2015,10,3)

        skirmish_dates = dates.map do |d|
          {
            date: d,
            during_5090: (Date.new(2015,7,4)..Date.new(2015,10,1)).include?(d),
            skirmishes: skirmishes_by_date[d] || [],
          }
        end

        @weeks = skirmish_dates.each_slice(7)
      end

      format.ics do
        calendar = Icalendar::Calendar.new

        @skirmishes.each do |skirmish|
          if skirmish.starts_at
            calendar.event do |e|
              e.dtstart = skirmish.starts_at
              e.dtend = skirmish.starts_at + 1.hour
              e.summary = '50/90 Skirmish'
              e.description = skirmish.url
              e.url = skirmish.url
            end
          end
        end

        calendar.timezone do |c|
          c.tzid = "America/New_York"

          c.daylight do |d|
            d.tzoffsetfrom =  "-0500"
            d.tzoffsetto = "-0400"
            d.tzname = "EDT"
            d.dtstart = "19700308T020000"
            d.rrule = "FREQ=YEARLY;BYMONTH=3;BYDAY=2SU"
          end

          c.standard do |s|
            s.tzoffsetfrom = "-0400"
            s.tzoffsetto = "-0500"
            s.tzname = "EST"
            s.dtstart = "19701101T020000"
            s.rrule = "FREQ=YEARLY;BYMONTH=11;BYDAY=1SU"
          end
        end

        calendar.publish

        render :text => calendar.to_ical
      end
    end
  end
end
