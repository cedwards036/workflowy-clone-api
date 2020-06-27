class User
  include Mongoid::Document
  include Mongoid::Timestamps
  field :email, type: String
  embeds_one :list
end
