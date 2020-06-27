class List
  include Mongoid::Document
  include Mongoid::Timestamps
  field :show_completed, type: Boolean
  embedded_in :user
  embeds_many :node
end
