require 'rails_helper'

RSpec.describe "Tags", type: :request do
  let(:list) {create(:list)}
  let!(:tag) {create(:tag, list: list)}
  let(:list_id) {list.id.to_s}
  let(:tag_id) { tag.id.to_s }

  describe 'GET /tags/:tag_id' do
    before { get "/tags/#{tag_id}" }

    context 'when the record exists' do
      it 'returns the tag' do
        expect(JSON.parse(response.body)).not_to be_empty
        expect(JSON.parse(response.body)['_id']).to eq(tag_id)
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
        expect(JSON.parse(response.body)['_id']).to eq(tag_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when no tag with that name exists' do
      it 'returns status code 404' do
        get "/lists/#{list_id}/tags?name=unknown_name"
        expect(response).to have_http_status(404)
      end
    end

    context 'when a tag with the same name exists but not in the current list' do
      let!(:other_tag) {create(:tag, name: "other_tag_name", list: create(:list))}

      it 'returns status code 404' do
        get "/lists/#{list_id}/tags?name=other_tag_name"
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST /tags' do
    let(:valid_attributes) { { 
      tag: {
        name: "a_new_tag",
      },
      list_id: list_id
    } }

    context 'when the request is valid' do
      before {post '/tags', params: valid_attributes}

      it 'creates a tag' do
        expect(JSON.parse(response.body)['name']).to eq('a_new_tag')
        expect(Tag.all.pluck(:name)).to include("a_new_tag")
      end

      it 'adds the tag to the tag\'s list' do
        expect(List.find(list_id).tags.pluck(:name)).to include('a_new_tag')
      end
    end

    context 'when the request is invalid' do
      it 'returns status code 400' do
        post '/tags', params: {foo: 'bar'}
        expect(response).to have_http_status(400)
      end
    end
  end
end
