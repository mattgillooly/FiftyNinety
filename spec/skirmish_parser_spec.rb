require 'skirmish_parser'

describe SkirmishParser::Parser do
  context "Sunday Skirmish 5, August 2nd , 3PM EST, 8PM pm in London; 12PM in LA;" do
    let(:title) {
      "Sunday Skirmish 5, August 2nd , 3PM EST, 8PM pm in London; 12PM in LA;"
    }

    it 'parses' do
      expect(subject.parse(title)).to eq(Time.utc(2015,8,2,19,0,0))
    end
  end

  context "Wednesday Skirmish 4 - Two Hours July 29th 2015 8pm GMT" do
    let(:title) {
      "Wednesday Skirmish 4 - Two Hours July 29th 2015 8pm GMT"
    }

    it 'parses' do
      expect(subject.parse(title)).to eq(Time.utc(2015,7,29,20,0,0))
    end
  end

  context "Anyone Planning a Superskirmish?" do
    let(:title) { "Anyone Planning a Superskirmish?" }

    it 'parses' do
      expect(subject.parse(title)).to eq(nil)
    end
  end

  context "Sunday Skirmish 4, July 26th, 3PM EST, 8PM pm in London; 12PM in LA;" do
    let(:title) {
      "Sunday Skirmish 4, July 26th, 3PM EST, 8PM pm in London; 12PM in LA;"
    }

    it 'parses' do
      expect(subject.parse(title)).to eq(Time.utc(2015,7,26,19,0,0))
    end
  end

  context "SATURDAY SKIRMISH JULY 25 \"Yesterday's News\" - 3:00 PM EST, 2:00 PM CST, 8:00 PM LONDON," do
    let(:title) {
      "SATURDAY SKIRMISH JULY 25 \"Yesterday's News\" - 3:00 PM EST, 2:00 PM CST, 8:00 PM LONDON,"
    }

    it 'parses' do
      expect(subject.parse(title)).to eq(Time.utc(2015,7,25,19,0,0))
    end
  end

  context "Wednesday Skirmish 3 - Two Hours July 22nd 2015 8pm GMT" do
    let(:title) { "Wednesday Skirmish 3 - Two Hours July 22nd 2015 8pm GMT" }

    it 'parses' do
      expect(subject.parse(title)).to eq(Time.utc(2015,7,22,20,0,0))
    end
  end

  context "Sunday Skirmish 3, July 19th, 3PM EST, 8PM pm in London; 12PM in LA;" do
    let(:title) {
      "Sunday Skirmish 3, July 19th, 3PM EST, 8PM pm in London; 12PM in LA;"
    }

    it 'parses' do
      expect(subject.parse(title)).to eq(Time.utc(2015,7,19,19,0,0))
    end
  end

  context "SATURDAY JULY 18 SKIRMISH Title: Random Destination 3:00 PM ET, 2:00 PM CT, 8:00 PM London, 9:00 PM Oslo" do
    let(:title) {
      "SATURDAY JULY 18 SKIRMISH Title: Random Destination 3:00 PM ET, 2:00 PM CT, 8:00 PM London, 9:00 PM Oslo"
    }

    it 'parses' do
      expect(subject.parse(title)).to eq(Time.utc(2015,7,18,19,0,0))
    end
  end

  context "Wednesday Skirmish 2 - Two Hours" do
    let(:title) { "Wednesday Skirmish 2 - Two Hours" }

    it 'parses'
  end

  context "Sunday Skirmish 2, July 12th, 3PM EST, 8PM pm in London; 12PM in LA;" do
    let(:title) {
      "Sunday Skirmish 2, July 12th, 3PM EST, 8PM pm in London; 12PM in LA;"
    }

    it 'parses' do
      expect(subject.parse(title)).to eq(Time.utc(2015,7,12,19,0,0))
    end
  end

  context "SATURDAY SKIRMISH \"WASTED SPACE\" July 11 - 3:00 PM EST - 7:00 PM UTC - 8:00PM London" do
    let(:title) {
      "SATURDAY SKIRMISH \"WASTED SPACE\" July 11 - 3:00 PM EST - 7:00 PM UTC - 8:00PM London"
    }

    it 'parses' do
      expect(subject.parse(title)).to eq(Time.utc(2015,7,11,19,0,0))
    end
  end

  context "Wednesday Skirmish 1 - two hours" do
    it 'parses'
  end

  context "Sunday Skirmish 1, July 5th, 3PM EST, 8PM pm in London; 12PM in LA;" do
    let(:title) {
      "Sunday Skirmish 1, July 5th, 3PM EST, 8PM pm in London; 12PM in LA;"
    }

    it 'parses' do
      expect(subject.parse(title)).to eq(Time.utc(2015,7,5,19,0,0))
    end
  end

  context "5090 Kickoff Skirmish(es)?" do
    let(:title) { "5090 Kickoff Skirmish(es)?" }

    it 'parses' do
      expect(subject.parse(title)).to eq(nil)
    end
  end
end
