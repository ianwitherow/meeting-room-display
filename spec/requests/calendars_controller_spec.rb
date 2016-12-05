require "rails_helper"

describe CalendarsController do
  it "loads and parses the feed from Google Calendar" do
    VCR.use_cassette("calendar_with_items") do
      get root_path

      calendar = assigns(:calendar)
      expect(calendar.location).to eq "Flexroom North (max 8)"
      expect(calendar).to have(7).items

      first_item = calendar.items.first
      expect(first_item.summary).to eq "SMS M Meeting"
      expect(first_item.begin_time.to_i).to eq 1480924800
      expect(first_item.end_time.to_i).to eq 1480932000
      expect(first_item.attendees).to match_array ["m.hoffmans@ultimaker.com",
                                                   "Gerard Garcia",
                                                   "Simone van den Heuvel",
                                                   "l.lesiputty@ultimaker.com",
                                                   "i.smeekes@ultimaker.com",
                                                   "s.tuijt@ultimaker.com",
                                                   "Tommes Heinemans"]
    end
  end
end
