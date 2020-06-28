require 'rails_helper'

RSpec.describe "Lists", type: :request do
  let!(:lists) { create_list(:list, 3) }
  let(:list_id) { lists.first.id.to_s }

  describe 'GET /lists/:id' do
    before { get "/lists/#{list_id}" }

    context 'when the record exists' do
      it 'returns the list' do
        expect(JSON.parse(response.body)).not_to be_empty
        expect(JSON.parse(response.body)['_id']['$oid']).to eq(list_id)
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
end
