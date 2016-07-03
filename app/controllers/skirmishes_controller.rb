class SkirmishesController < ApplicationController
  YEAR = 2016
  START_DATE = Date.new(YEAR, 7, 4)
  END_DATE = START_DATE + 89
  DATES_FOR_CALENDAR = START_DATE.beginning_of_week(:sunday)..END_DATE.end_of_week(:sunday)

  # GET /skirmishes
  # GET /skirmishes.ics
  def index
    @current_page_title = 'Skirmishes'
    @skirmishes = Skirmish.order('starts_at desc NULLS LAST').all

    respond_to do |format|
      format.html do
        skirmishes_by_date = @skirmishes.select(&:starts_at).
          group_by{|s| s.starts_at.to_date}

        skirmish_dates = DATES_FOR_CALENDAR.map do |d|
          {
            date: d,
            during_5090: (Date.new(2016,7,4)..Date.new(2016,10,1)).include?(d),
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
              e.dtstart = skirmish.starts_at.strftime('%Y%m%dT%H%M%SZ')
              e.dtend = (skirmish.starts_at + 1.hour).strftime('%Y%m%dT%H%M%SZ')
              e.summary = '50/90 Skirmish'
              e.description = skirmish.url
              e.url = skirmish.url
            end
          end
        end

        calendar.publish

        render :text => calendar.to_ical
      end
    end
  end
end
