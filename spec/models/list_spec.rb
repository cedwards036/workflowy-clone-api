require 'rails_helper'

RSpec.describe List, type: :model do
  it {should have_many :nodes}
  it {should have_one :root_node}
  it {should have_many :tags}
end
