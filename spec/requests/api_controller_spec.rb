require "rails_helper"

describe ApiController, type: :request do
  def get_path(path)
    get path, {}, {
      "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials("ultimaker", "ultimaker2011")
    }
  end

  it "loads and parses Google Calendars" do
    VCR.use_cassette("calendars_api") do
      get_path calendars_api_path

      parsed_response = JSON.parse(response.body)
      expect(parsed_response.size).to eq(8)

      calendar = parsed_response.first
      expect(calendar["name"]).to eq("Flexroom North")
      expect(calendar["calendar_id"]).to eq("ultimaker.com_33313636373633363835@resource.calendar.google.com")
    end
  end

  it "loads and parses a specific calendar" do
    Timecop.freeze(2016, 12, 7, 11, 0) do
      VCR.use_cassette("calendar_api") do
        get_path calendar_api_path("ultimaker.com_33313636373633363835@resource.calendar.google.com")

        calendar = JSON.parse(response.body)

        expect(calendar["name"]).to eq "Flexroom North"
        expect(calendar["calendar_id"]).to eq("ultimaker.com_33313636373633363835@resource.calendar.google.com")

        event = calendar["events"].first
        expect(event["summary"]).to eq "Skype with Blanca & Lily @UltimakerGB"
        expect(event["begin_time"].to_time).to eq(Time.new(2016, 12, 7, 10, 30))
        expect(event["end_time"].to_time).to eq(Time.new(2016, 12, 7, 11, 30))
        expect(event["attendees"]).to match_array ["Blanca Bolaños",
                                                  "B. Timmermans",
                                                  "C. Mcadam",
                                                  "L. Lesiputty"]
      end
    end
  end
end

