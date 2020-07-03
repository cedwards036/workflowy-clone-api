FactoryBot.define do
  factory :tag do
    name { Faker::Lorem.unique.word }
  end
end
