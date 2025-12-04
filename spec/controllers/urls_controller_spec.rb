# spec/requests/urls_spec.rb
require 'rails_helper'

RSpec.describe "Urls", type: :request do
  describe "POST /encode" do
    let(:original_url) { "https://example.com" }

    before do
      allow_any_instance_of(ActionDispatch::Request)
        .to receive(:base_url).and_return("https://google.com")
    end


    it "creates a new short URL" do
      post encode_path, params: { url: { original_url: original_url } }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["short_url"]).to be_present
    end

    it "returns existing hash if URL already exists" do
      existing_hash = UrlEncoderService.encode(original_url)

      post encode_path, params: { url: { original_url: original_url } }

      json = JSON.parse(response.body)
      expect(json["short_url"]).to eq("https://google.com/#{existing_hash}")
    end
  end


  describe "POST /decode" do
    let(:short_url) { "https://example.com/127kkhgu" }

    it "return error if not existing url" do
      post decode_path, params: { url: { short_url: short_url } }

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["original_url"]).to be_nil
    end

    it "returns existing hash if URL already exists" do
      existing_hash = UrlEncoderService.decode(short_url)

      post decode_path, params: { url: { short_url: short_url } }

      json = JSON.parse(response.body)
      expect(json["original_url"]).to eq(existing_hash)
    end
  end
end
