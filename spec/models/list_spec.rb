require 'rails_helper'

RSpec.describe List, type: :model do
  it {should be_embedded_in :user}
  it {should embed_many :node}
end
