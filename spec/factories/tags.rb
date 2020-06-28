FactoryBot.define do
  factory :tag do
    list
    name { Faker::Lorem.word }
  end
end
