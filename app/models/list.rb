class List
  include Mongoid::Document
  include Mongoid::Timestamps
  field :show_completed, type: Boolean
  has_many :nodes, class_name: "Node", inverse_of: :list
  has_one :root_node, class_name: "Node", inverse_of: :parent_list
  has_many :tags

  def root_node_id
    root_node.id
  end
end
