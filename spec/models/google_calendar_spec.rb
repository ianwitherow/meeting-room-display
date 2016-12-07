describe GoogleCalendar do
  describe "#available_calendars" do
    it "tells the user what other calendars are available" do
      event_now = create(:event, begin_time: 4.minutes.ago, end_time: 10.minutes.from_now)
      event_future = create(:event, begin_time: 4.minutes.from_now, end_time: 10.minutes.from_now)
      event_past = create(:event, begin_time: 4.minutes.ago, end_time: 2.minutes.ago)

      unavailable_calendar = create(:calendar, events: [event_now])
      unavailable_calendar_2 = create(:calendar, events: [event_past, event_now])
      available_calendar_1 = create(:calendar, events: [event_past])
      available_calendar_2 = create(:calendar, events: [event_past])
      available_calendar_3 = create(:calendar, events: [event_future])
      available_calendar_4 = create(:calendar, events: [event_past, event_future])

      allow_any_instance_of(GoogleCalendar).to receive(:calendars).and_return([unavailable_calendar,
                                                                               unavailable_calendar_2,
                                                                               available_calendar_1,
                                                                               available_calendar_2,
                                                                               available_calendar_3,
                                                                               available_calendar_4])

      available_calendars = GoogleCalendar.new(request: nil).available_calendars

      expect(available_calendars).to match_array [available_calendar_1,
                                                  available_calendar_2,
                                                  available_calendar_3,
                                                  available_calendar_4]

      expect(available_calendars.first).to have(1).event
    end
  end

end
