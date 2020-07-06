require 'rails_helper'

RSpec.describe Node, type: :model do
  it {should have_many(:children).of_type(Node).with_dependent(:destroy)}
  it {should belong_to(:parent_node).of_type(Node)}
  it {should belong_to(:parent_list).of_type(List)}
  it {should belong_to(:list)}
  it {should have_and_belong_to_many :tags}
  it {should validate_presence_of :completed}
  it {should validate_presence_of :expanded}
end
