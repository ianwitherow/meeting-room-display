require "rails_helper"

describe CalendarsController, type: :request do
  it "loads and parses the feed from Google Calendar" do
    env = {
        "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials("ultimaker", "ultimaker2011")
    }

    VCR.use_cassette("calendar_with_items") do |cassette|
      Timecop.freeze(cassette.originally_recorded_at || Time.now) do
        get calendar_path("ultimaker.com_33313636373633363835@resource.calendar.google.com"), {}, env

        calendar = assigns(:calendar)
        expect(calendar.location).to eq "Flexroom North (max 8)"
        expect(calendar).to have(4).events

        event = calendar.events.first
        expect(event.summary).to eq "Skype with Blanca & Lily @UltimakerGB"
        expect(event.begin_time.to_i).to eq 1481103000
        expect(event.end_time.to_i).to eq 1481106600
        expect(event.attendees).to match_array ["Blanca Bolaños",
                                                "b.timmermans@ultimaker.com",
                                                "c.mcadam@ultimaker.com",
                                                "l.lesiputty@ultimaker.com",
                                                "s.tuijt@ultimaker.com"]
      end
    end
  end
end
