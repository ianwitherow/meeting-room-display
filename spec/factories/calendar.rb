FactoryGirl.define do
  factory :calendar do
    location "Flexroom North (max 8)"
    items { build_list(:event, 1) }

    skip_create
    initialize_with { Calendar.new(nil) }
  end
end
