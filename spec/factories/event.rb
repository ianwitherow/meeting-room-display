FactoryGirl.define do
  factory :event do
    summary "Meeting Sales"
    begin_time { 1.minute.ago }
    end_time { 1.hour.from_now }
    attendees { ["m.pors@ultimaker.com",
                 "Marie-Louise Goes",
                 "s.tuijt@ultimaker.com",
                 "p.roeffen@ultimaker.com",
                 "b.timmermans@ultimaker.com",
                 "Blanca Bolaños"] }

    skip_create
    initialize_with { Event.new(nil) }
  end
end
