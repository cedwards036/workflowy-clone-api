class Node
  include Mongoid::Document
  include Mongoid::Timestamps
  field :text, type: String
  field :completed, type: Boolean
  field :expanded, type: Boolean
  has_and_belongs_to_many :tags
  has_many :children, class_name: 'Node'
  belongs_to :parent_node, class_name: 'Node', optional: true
  belongs_to :list, class_name: 'List', inverse_of: :nodes
  belongs_to :parent_list, class_name: 'List', inverse_of: :root_node, optional: true

  validates_presence_of :completed, :expanded

  def tag_names
    tags.map {|tag| tag[:name]}
  end

  def child_ids
    children.pluck(:id)
  end
end
