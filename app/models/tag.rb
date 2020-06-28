class Tag
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  has_and_belongs_to_many :nodes
  belongs_to :list

  validates_presence_of :name
  validates_uniqueness_of :name, scope: :list
end
