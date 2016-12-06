describe Event do
  describe "#duration" do
    it "returns the duration" do
      Timecop.freeze(DateTime.new(2016, 12, 5, 9))
      event = create(:event, begin_time: 10.minutes.ago, end_time: 5.minutes.from_now)
      expect(event.duration).to eq 15.minutes
    end
  end

  describe "#overlapping" do
    it "is true when the event overlaps another" do
      event_1 = create(:event, begin_time: 3.hours.ago, end_time: 1.hour.ago)
      event_2 = create(:event, begin_time: 2.hours.ago, end_time: Time.zone.now)

      calendar = create(:calendar, events: [event_1, event_2])

      event_1.calendar = calendar
      event_2.calendar = calendar

      expect(event_1).to be_overlapping
      expect(event_2).to be_overlapping
    end

    it "is false when the event doesn't overlap others" do
      event_1 = create(:event, begin_time: 3.hours.ago, end_time: 2.hours.ago)
      event_2 = create(:event, begin_time: 2.hour.ago, end_time: Time.zone.now)

      calendar = create(:calendar, events: [event_1, event_2])

      event_1.calendar = calendar
      event_2.calendar = calendar

      expect(event_1).not_to be_overlapping
      expect(event_2).not_to be_overlapping
    end
  end
end
