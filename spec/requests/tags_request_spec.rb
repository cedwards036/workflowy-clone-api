require 'rails_helper'

RSpec.describe "Tags", type: :request do
  let!(:tag) {create(:tag)}
  let(:list) {tag.list}
  let(:list_id) {list.id.to_s}
  let(:tag_id) { tag.id.to_s }

  describe 'GET /lists/:list_id/tags/:tag_id' do
    before { get "/lists/#{list_id}/tags/#{tag_id}" }

    context 'when the record exists' do
      it 'returns the tag' do
        expect(JSON.parse(response.body)).not_to be_empty
        expect(JSON.parse(response.body)['_id']['$oid']).to eq(tag_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:tag_id) { 123 }
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Document\(s\) not found for class Tag with id\(s\) #{tag_id}/)
      end
    end
  end

  describe 'GET /lists/:list_id/tags?name=:name' do
    context 'when the record exists' do
      before { get "/lists/#{list_id}/tags?name=#{tag.name}" }

      it 'returns the tag' do
        expect(JSON.parse(response.body)).not_to be_empty
        expect(JSON.parse(response.body)['_id']['$oid']).to eq(tag_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      before { get "/lists/#{list_id}/tags?name=unknown_name" }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end
