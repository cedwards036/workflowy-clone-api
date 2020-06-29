class Node
  include Mongoid::Document
  include Mongoid::Timestamps
  field :text, type: String
  field :completed, type: Boolean
  field :expanded, type: Boolean
  has_and_belongs_to_many :tags
  has_many :child_nodes, :class_name => 'Node'
  belongs_to :parent_node, :class_name => 'Node', optional: true
  belongs_to :list, optional: true

  validates_presence_of :text, :completed, :expanded
end
