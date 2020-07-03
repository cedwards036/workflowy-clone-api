require 'rails_helper'

RSpec.describe "Lists", type: :request do
  let!(:list) {create(:list)}
  let!(:root_node) {list.root_node}
  let!(:child_node) {create(:node, list: list, parent_node: root_node)}
  let(:list_id) { list.id.to_s }

  describe 'GET /lists/:id' do
    before { get "/lists/#{list_id}" }

    context 'when the record exists' do
      it 'returns the list' do
        expect(JSON.parse(response.body)['_id']).to eq(list_id)
      end

      it 'returns the root node id' do
        expect(JSON.parse(response.body)['root_node_id']).to eq(root_node.id.to_s)
      end

      it 'includes tag names in child nodes' do
        root = JSON.parse(response.body)['nodes'][0]
        expect(root['tag_names'].length).to eq(2)
      end

      it 'includes all tag names associated with the list' do
        expect(JSON.parse(response.body)['tag_names'].length).to eq(4)
      end

      it 'includes child node ids in each of its nodes' do
        root = JSON.parse(response.body)['nodes'][0]
        expect(root['child_ids'][0]).to eq(child_node.id.to_s)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:list_id) { 123 }
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Document\(s\) not found for class List with id\(s\) #{list_id}/)
      end
    end
  end

  describe "POST /lists" do
    let(:valid_attributes) { { 
      list: {
        show_completed: false,
      }
    } }

    context 'when the request is valid' do
      before {post '/lists', params: valid_attributes}

      it 'creates a list with a root node' do
        expect(JSON.parse(response.body)['show_completed']).to eq(false)
        expect(JSON.parse(response.body)['nodes'].length).to eq(1)
        new_root_node = JSON.parse(response.body)['nodes'][0]
        expect(JSON.parse(response.body)['root_node_id']).to eq(new_root_node['_id'])
        expect(List.all).not_to be_empty
      end
    end

    context 'when the request is invalid' do
      it 'returns status code 400' do
        post '/lists', params: {foo: 'bar'}
        expect(response).to have_http_status(400)
      end
    end
  end
end
