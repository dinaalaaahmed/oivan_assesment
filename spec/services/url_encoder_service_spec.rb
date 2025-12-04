require 'rails_helper'
RSpec.describe UrlEncoderService do
  describe "#encode" do
    it "generates a Base62 short hash" do
      short_url = UrlEncoderService.encode("https://google.com")

      expect(short_url).to be_a(String)
      expect(short_url.length).to be > 0
    end

    it "stores the URL in the database" do
      short_url = UrlEncoderService.encode("https://google.com")

      record = Url.find_by(url_hash: short_url)
      expect(record.original_url).to eq("https://google.com")
    end

    it "returns the same record from database and doesn't create new code" do
      short_url_1 = UrlEncoderService.encode("https://google.com")
      short_url_2 = UrlEncoderService.encode("https://google.com")

      record = Url.find_by(url_hash: short_url_1)
      expect(record).to_not eq(nil)
      expect(short_url_1).to eq(short_url_2)
    end

    it "throws an error for invalid url" do
      expect {
        UrlEncoderService.encode("google.com")
      }.to raise_error(ActiveRecord::RecordInvalid, /Original url is not a valid URL/)
    end
  end

  describe "#decode" do
    it "returns the original URL" do
      short_url = UrlEncoderService.encode("https://google.com")
      decoded = UrlEncoderService.decode(short_url)

      expect(decoded).to eq("https://google.com")
    end

    it "returns the same code for multiple decode calls" do
      short_url = UrlEncoderService.encode("https://google.com")
      decoded_1 = UrlEncoderService.decode(short_url)
      decoded_2 = UrlEncoderService.decode(short_url)

      expect(decoded_1).to eq("https://google.com")
      expect(decoded_2).to eq("https://google.com")
    end
  end
end
