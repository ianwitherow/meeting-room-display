describe Calendar do
  describe "#description" do
    it "tells who is using the room and until when" do
      Timecop.freeze(DateTime.new(2016, 12, 5, 9, 0, 0, "+1")) do
        events = create_list(:event, 1,
                             begin_time: 4.minutes.ago,
                             end_time: 10.minutes.from_now,
                             attendees: ["Jankees van Woezik", "Rowan Zajkowski", "Davy Cardinaal"])

        calendar = create(:calendar, events: events)

        expect(calendar.description).to eq "This room is used by Jankees van Woezik, Rowan Zajkowski and Davy Cardinaal until 09:10 (10 minutes left)"
      end
    end

    it "tells you when the room is available" do
      calendar = create(:calendar, events: [])
      expect(calendar.description).to eq "This room is available"
    end
  end

  describe "#time_left" do
    it "returns the time left for current meeting" do
      Timecop.freeze(DateTime.new(2016, 12, 5, 9, 0, 0, "+1")) do
        events = []
        events << create(:event, begin_time: 1.hour.ago, end_time: 5.minutes.ago, summary: "Stand up")
        events << create(:event, begin_time: 4.minutes.ago, end_time: 10.minutes.from_now, summary: "Planning")
        calendar = create(:calendar, events: events)

        expect(calendar.time_left).to eq "10 minutes left"
      end
    end

    it "returns the time left until the next meeting starts" do
      Timecop.freeze(DateTime.new(2016, 12, 5, 9, 0, 0, "+1")) do
        events = []
        events << create(:event, begin_time: 1.hour.ago, end_time: 5.minutes.ago)
        events << create(:event, begin_time: 3.minutes.from_now, end_time: 10.minutes.from_now)
        calendar = create(:calendar, events: events)

        expect(calendar.time_left).to eq "3 minutes left"
      end
    end

    it "does not crash without data" do
      calendar = create(:calendar, events: [])
      expect(calendar.time_left).to eq ""
    end

    it "returns something useful for all day events" do
      event = create(:event, :all_day)
      calendar = create(:calendar, events: [event])
      expect(calendar.time_left).to eq "this meeting takes all day"
    end
  end

  describe "#available? and #in_use?" do
    it "tells you if there is a meeting going on" do
      Timecop.freeze(DateTime.new(2016, 12, 5, 9, 0)) do
        events = create_list(:event, 1, begin_time: 4.minutes.ago, end_time: 10.minutes.from_now)
        calendar = create(:calendar, events: events)
        expect(calendar.available?).to be_falsey
        expect(calendar.in_use?).to be_truthy
      end
    end

    it "does not crash without data" do
      calendar = create(:calendar, events: [])
      expect(calendar.available?).to be_truthy
      expect(calendar.in_use?).to be_falsey
    end
  end

  describe "#current_meeting" do
    it "returns an all-day meeting" do
      Timecop.freeze(DateTime.new(2016, 12, 5, 9, 0)) do
        event = create(:event, :all_day, summary: "Meeting day")
        calendar = create(:calendar, events: [event])

        expect(calendar.current_meeting).to be_a Event
        expect(calendar.current_meeting.summary).to eq "Meeting day"
      end
    end

    it "returns the current meeting" do
      Timecop.freeze(DateTime.new(2016, 12, 5, 9, 0)) do
        events = []
        events << create(:event, begin_time: 1.hour.ago, end_time: 5.minutes.ago, summary: "Stand up")
        events << create(:event, begin_time: 4.minutes.ago, end_time: 10.minutes.from_now, summary: "Planning")
        calendar = create(:calendar, events: events)

        expect(calendar.current_meeting).to be_a Event
        expect(calendar.current_meeting.summary).to eq "Planning"
      end
    end

    it "does not return a rejected meeting" do
      Timecop.freeze(DateTime.new(2016, 12, 5, 9, 0)) do
        event = create(:event, :rejected, begin_time: 4.minutes.ago, end_time: 10.minutes.from_now)
        calendar = create(:calendar, events: [event])

        expect(calendar.current_meeting).to be_nil
      end
    end

    it "does not crash without data" do
      calendar = create(:calendar, events: [])
      expect(calendar.current_meeting).to be_nil
    end
  end
end
