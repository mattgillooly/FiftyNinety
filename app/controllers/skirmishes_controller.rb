class SkirmishesController < ApplicationController

  DEFAULT_ZONE = ActiveSupport::TimeZone["America/New_York"]

  # GET /skirmishes
  # GET /skirmishes.ics
  def index
    @skirmishes = Skirmish.all

    respond_to do |format|
      format.html # index.html.erb
      format.ics do
        calendar = Icalendar::Calendar.new

        @skirmishes.each do |skirmish|
          if skirmish.starts_at
            url = 'http://fiftyninety.fawmers.org/' + skirmish.remote_url
            calendar.event do |e|
              e.dtstart = skirmish.starts_at
              e.dtend = skirmish.starts_at + 1.hour
              e.summary = '50/90 Skirmish'
              e.description = url
              e.url = url
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
