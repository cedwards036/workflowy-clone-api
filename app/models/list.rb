class List
  include Mongoid::Document
  include Mongoid::Timestamps
  field :show_completed, type: Boolean
  embeds_many :nodes
  has_many :tags
end
