class List
  include Mongoid::Document
  include Mongoid::Timestamps
  field :show_completed, type: Boolean
  has_many :nodes, class_name: "Node", inverse_of: :list
  has_many :child_nodes, class_name: "Node", inverse_of: :parent_list
  has_many :tags
end
