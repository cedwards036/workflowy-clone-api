FactoryBot.define do
  factory :node do
    list
    parent_list {list}
    text { Faker::TvShows::BojackHorseman.quote }
    completed {Faker::Boolean.boolean(true_ratio: 0.5)}
    expanded {Faker::Boolean.boolean(true_ratio: 0.5)}

    factory :node_with_descendents do
      transient do
        depth { 2 }
      end

      after(:create) do |node, evaluator|
        if evaluator.depth > 0
          create(:node_with_descendents, depth: evaluator.depth - 1, parent_node: node)
        end
      end
    end
  end
end
