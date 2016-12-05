require "rails_helper"

describe CalendarsController do
  it "loads and parses the feed from Google Calendar" do
    VCR.use_cassette("calendar_with_items") do
      get calendar_path("ultimaker.com_33313636373633363835@resource.calendar.google.com")

      calendar = assigns(:calendar)
      expect(calendar.location).to eq "Flexroom North (max 8)"
      expect(calendar).to have(7).events

      event = calendar.events.first
      expect(event.summary).to eq "SMS M Meeting"
      expect(event.begin_time.to_i).to eq 1480924800
      expect(event.end_time.to_i).to eq 1480932000
      expect(event.attendees).to match_array ["m.hoffmans@ultimaker.com",
                                              "l.lesiputty@ultimaker.com",
                                              "i.smeekes@ultimaker.com",
                                              "Tommes Heinemans"]
    end
  end
end
