require 'rails_helper'

RSpec.describe "Nodes", type: :request do
  let!(:nodes) { create_list(:node, 5) }
  let(:node_id) { nodes.first.id.to_s }
  let(:list_id) { nodes.first.list_id.to_s}

  describe 'GET /nodes/:id' do
    before { get "/nodes/#{node_id}" }

    context 'when the record exists' do
      it 'returns the node' do
        expect(JSON.parse(response.body)).not_to be_empty
        expect(JSON.parse(response.body)['id']).to eq(node_id)
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

  describe 'POST /nodes' do
    context 'when adding a node to a parent node' do
      let(:valid_attributes) { { 
        node: {
          text: 'This is a node', 
          completed: false,
          expanded: false,
          tag_names: ['tag1', 'tag2'],
          parent_node_id: node_id, 
          list_id: list_id
        }, 
      } }

      context 'when the request is valid' do
        before {post '/nodes', params: valid_attributes}

        it 'creates a node' do
          expect(JSON.parse(response.body)['text']).to eq('This is a node')
        end

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end

        it 'creates the tags if they do not already exist' do
          tags = Tag.all
          expect(tags[0]['name']).to eq('tag1')
          expect(tags[1]['name']).to eq('tag2')
        end

        it 'adds the tags to the node' do
          expect(JSON.parse(response.body)['tag_names']).to eq(['tag1', 'tag2'])
        end

        it 'references the node in the parent' do
          expect(Node.find(node_id).child_nodes.length).to eq(1)
        end
      end

      context 'when the request is invalid' do
        context 'because of the response format' do
          it 'returns status code 400' do
            post '/nodes', params: {foo: 'bar'}
            expect(response).to have_http_status(400)
          end
        end
        context 'because of an invalid parent id' do
          it 'returns status code 404' do
            post '/nodes', params: { 
              node: {
                text: 'This is a node', 
                completed: false,
                expanded: false,
                tag_names: [],
                parent_node_id: 'some invalid id', 
                list_id: list_id
              }, 
            }
            expect(response).to have_http_status(404)
          end
        end
      end
    end
    
    context "when adding a node directly to a list" do
      let(:list) {nodes.first.list}
      let(:valid_attributes) { { 
        node: {
          text: 'This is a node', 
          completed: false,
          expanded: false,
          tag_names: [],
          parent_list_id: list_id, 
          list_id: list_id
        }
      } }

      context 'when the request is valid' do
        before {post "/nodes", params: valid_attributes}

        it 'creates a node' do
          expect(JSON.parse(response.body)['text']).to eq('This is a node')
        end

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end

        it 'references the node in the parent' do
          expect(List.find(list_id).nodes[1]['text']).to eq('This is a node')
        end
      end

      context 'when the request is invalid' do
        context 'because of the response format' do
          it 'returns status code 400' do
            post "/nodes", params: {foo: 'bar'}
            expect(response).to have_http_status(400)
          end
          context 'because of an invalid parent id' do
            it 'returns status code 404' do
              post '/nodes', params: { 
                node: {
                  text: 'This is a node', 
                  completed: false,
                  expanded: false,
                  tag_names: [],
                  list_id: list_id,
                  parent_list_id: 'some_invalid_id'
                }, 
              }
              expect(response).to have_http_status(404)
            end
          end
        end
      end
    end
  end

  describe 'PUT /nodes/:id' do
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

  describe 'DELETE /nodes/:id' do
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
