FactoryBot.define do
  factory :list do
    show_completed {Faker::Boolean.boolean(true_ratio: 0.5)}
    after(:create) do |list| 
      list.root_node = list.nodes.create(attributes_for(:node))
      list.root_node.tags << create_list(:tag, 2, list: list)
    end
  end
end
