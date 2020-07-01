require 'rails_helper'

RSpec.describe "Lists", type: :request do
  let!(:child_node) {create(:node_with_descendents, depth: 1, tags_count: 2)}
  let!(:list) { child_node.list }
  let(:list_id) { list.id.to_s }

  describe 'GET /lists/:id' do
    before { get "/lists/#{list_id}" }

    context 'when the record exists' do
      it 'returns the list' do
        expect(JSON.parse(response.body)['id']).to eq(list_id)
      end

      it 'returns all descendent nodes in the list' do
        grandchildren = JSON.parse(response.body)['child_nodes'][0]['child_nodes']
        expect(grandchildren.length).to eq(1)
      end

      it 'includes tag names in child nodes' do
        child = JSON.parse(response.body)['child_nodes'][0]
        expect(child['tag_names'].length).to eq(2)
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

      it 'creates a list' do
        expect(JSON.parse(response.body)['show_completed']).to eq(false)
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
