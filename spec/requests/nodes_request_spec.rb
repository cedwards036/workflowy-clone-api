require 'rails_helper'

RSpec.describe "Nodes", type: :request do
  let!(:list) {create(:list)}
  let!(:node) {create(:node, list: list, parent_node: list.root_node)}
  let(:node_id) { node.id.to_s }
  let(:list_id) { list.id.to_s}

  describe 'GET nodes/:id' do
    before { get "/nodes/#{node_id}" }

    context 'when the record exists' do
      it 'returns the node' do
        expect(JSON.parse(response.body)).not_to be_empty
        expect(JSON.parse(response.body)['_id']).to eq(node_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:node_id) { 123 }
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Document\(s\) not found for class Node with id\(s\) #{node_id}/)
      end
    end
  end

  describe 'POST lists/:list_id/nodes' do
    let(:valid_attributes) { { 
      node: {
        text: 'This is a node', 
        completed: false,
        expanded: false,
        tag_names: ['tag1', 'tag2'],
        parent_node_id: node_id
      }, 
    } }

    context 'when the request is valid' do
      before {post "/lists/#{list_id}/nodes", params: valid_attributes}

      it 'creates a node' do
        expect(JSON.parse(response.body)['text']).to eq('This is a node')
      end

      it 'autopopulates the list ID from the parent' do
        expect(JSON.parse(response.body)['list_id']).to eq(list_id)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'creates the tags if they do not already exist' do
        tag_names = Tag.all.pluck(:name)
        expect(tag_names).to include('tag1')
        expect(tag_names).to include('tag2')
      end

      it 'adds the tags to the node' do
        expect(JSON.parse(response.body)['tag_names']).to eq(['tag1', 'tag2'])
      end

      it 'references the node in the parent' do
        expect(node.children.length).to eq(1)
      end

      it 'references the node in the list' do
        expect(list.nodes.length).to eq(3)
      end
    end

    context 'when the request is invalid' do
      context 'because of the response format' do
        it 'returns status code 400' do
          post "/lists/#{list_id}/nodes", params: {foo: 'bar'}
          expect(response).to have_http_status(400)
        end
      end
      context 'because of an invalid parent id' do
        it 'returns status code 404' do
          post "/lists/#{list_id}/nodes", params: { 
            node: {
              text: 'This is a node', 
              completed: false,
              expanded: false,
              tag_names: [],
              parent_node_id: 'some invalid id'
            }, 
          }
          expect(response).to have_http_status(404)
        end
      end
    end
  end

  describe 'PUT nodes/:id' do
    let(:valid_attributes) { { 
      node: {
        text: 'Some new text', 
        completed: true,
        expanded: true,
        tag_names: ['a_new_tag']
      }
    } }
    context 'when the record exists' do
      before { put "/nodes/#{node_id}", params: valid_attributes }
      it 'updates the record' do
        updated_node = Node.find(node_id)
        expect(updated_node['text']).to eq('Some new text')
        expect(updated_node['completed']).to be(true)
        expect(updated_node['expanded']).to be(true)
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the record does not exist' do
      before { put "/nodes/invalid_id", params: valid_attributes }
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'DELETE lists/:list_id/nodes/:id' do
    context 'when the record exists' do
      before { delete "/nodes/#{node_id}" }
      it 'deletes the record' do
        expect { Node.find(node_id) }.to raise_error(Mongoid::Errors::DocumentNotFound)
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when the record does not exist' do
      before { delete "/nodes/invalid_id" }
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end
