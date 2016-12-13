FactoryGirl.define do
  factory :calendar do
    location "Flexroom North"
    events { build_list(:event, 1) }

    skip_create
    initialize_with { Calendar.new(nil) }
  end
end
