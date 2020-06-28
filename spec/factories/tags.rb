FactoryBot.define do
  factory :tag do
    list
    name { Faker::Music::Opera.verdi }
  end
end
