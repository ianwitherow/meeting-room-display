describe Calendar do
  describe "#time_left_in_current_meeting" do
    it "returns the time left for current meeting" do
      Timecop.freeze(DateTime.new(2016, 12, 5, 9, 0)) do
        events = []
        events << create(:event, begin_time: 1.hour.ago, end_time: 5.minutes.ago, summary: "Stand up")
        events << create(:event, begin_time: 4.minutes.ago, end_time: 10.minutes.from_now, summary: "Planning")
        calendar = create(:calendar, items: events)

        expect(calendar.time_left_in_current_meeting).to eq 10.minutes
      end
    end

    it "does not crash without data" do
      calendar = create(:calendar, items: [])
      expect(calendar.time_left_in_current_meeting).to be_nil
    end
  end

  describe "#available? and #in_use?" do
    it "tells you if there is a meeting going on" do
      Timecop.freeze(DateTime.new(2016, 12, 5, 9, 0)) do
        items = create_list(:event, 1, begin_time: 4.minutes.ago, end_time: 10.minutes.from_now)
        calendar = create(:calendar, items: items)
        expect(calendar.available?).to be_falsey
        expect(calendar.in_use?).to be_truthy
      end
    end

    it "does not crash without data" do
      calendar = create(:calendar, items: [])
      expect(calendar.available?).to be_truthy
      expect(calendar.in_use?).to be_falsey
    end
  end

  describe "#current_meeting" do
    it "returns the current meeting" do
      Timecop.freeze(DateTime.new(2016, 12, 5, 9, 0)) do
        events = []
        events << create(:event, begin_time: 1.hour.ago, end_time: 5.minutes.ago, summary: "Stand up")
        events << create(:event, begin_time: 4.minutes.ago, end_time: 10.minutes.from_now, summary: "Planning")
        calendar = create(:calendar, items: events)

        expect(calendar.current_meeting).to be_a Event
        expect(calendar.current_meeting.summary).to eq "Planning"
      end
    end

    it "does not crash without data" do
      calendar = create(:calendar, items: [])
      expect(calendar.current_meeting).to be_nil
    end
  end
end
