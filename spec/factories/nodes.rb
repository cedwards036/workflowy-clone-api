FactoryBot.define do
  factory :node do
    text { Faker::TvShows::BojackHorseman.quote }
    completed {Faker::Boolean.boolean(true_ratio: 0.5)}
    expanded {Faker::Boolean.boolean(true_ratio: 0.5)}
  end
end
