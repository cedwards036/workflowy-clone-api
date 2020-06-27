FactoryBot.define do
  factory :node do
    text { Faker::TvShows::BojackHorseman.quote }
    completed {false}
    expanded {true}
  end
end
