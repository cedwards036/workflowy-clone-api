class Node
  include Mongoid::Document
  include Mongoid::Timestamps
  field :text, type: String
  field :completed, type: Boolean
  field :expanded, type: Boolean
  has_and_belongs_to_many :tags
  has_many :child_nodes, class_name: 'Node'
  belongs_to :list, class_name: 'List', inverse_of: :nodes
  belongs_to :parent_node, class_name: 'Node', optional: true
  belongs_to :parent_list, class_name: 'List', optional: true, inverse_of: :child_nodes

  validates_presence_of :text, :completed, :expanded

  def tag_names
    tags.map {|tag| tag[:name]}
  end
end
