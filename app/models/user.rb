class User
  include Mongoid::Document
  include Mongoid::Timestamps
  field :email, type: String
  embeds_one :list

  validates_presence_of :email
  validates_uniqueness_of :email
end
