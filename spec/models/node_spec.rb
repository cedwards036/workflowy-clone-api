require 'rails_helper'

RSpec.describe Node, type: :model do
  it {should embed_many(:child_nodes).of_type(Node)}
  it {should be_embedded_in(:parent_node).of_type(Node)}
  it {should be_embedded_in(:list)}
  it {should have_and_belong_to_many :tags}
  it {should validate_presence_of :text}
end
