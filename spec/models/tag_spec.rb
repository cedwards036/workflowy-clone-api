require 'rails_helper'

RSpec.describe Tag, type: :model do
  it {should have_and_belong_to_many :nodes}
  it {should validate_presence_of :name}
end
