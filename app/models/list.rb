class List
  include Mongoid::Document
  include Mongoid::Timestamps
  field :show_completed, type: Boolean
  has_many :nodes
  has_many :tags
end
