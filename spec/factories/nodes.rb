FactoryBot.define do
  factory :node do
    text { Faker::TvShows::BojackHorseman.quote }
    completed {Faker::Boolean.boolean(true_ratio: 0.5)}
    expanded {Faker::Boolean.boolean(true_ratio: 0.5)}

    transient do 
      tags_count { 2 }
    end

    after(:create) do |node, evaluator|
      node.tags << create_list(:tag, evaluator.tags_count, nodes: [node], list: node.list)
    end

    factory :node_with_descendents do
      transient do
        depth { 2 }
      end

      after(:create) do |node, evaluator|
        if evaluator.depth > 0
          create(:node_with_descendents, depth: evaluator.depth - 1, node: node)
        end
      end
    end
  end
end
