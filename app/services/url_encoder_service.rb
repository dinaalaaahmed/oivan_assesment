require 'digest'

class UrlEncoderService
  class << self

    def encode(original_url)
        existing_hash = Url.where(original_url: original_url).limit(1).pluck(:url_hash).first
        return existing_hash if existing_hash

        loop do
            hash = generate_hash(original_url)
            conflict = Url.where(url_hash: hash).limit(1).pluck(:url_hash).first
            next if conflict

            url = Url.create!(original_url: original_url, url_hash: hash)
            return url.url_hash
        end
    end


    def decode(short_url)
        Url.where(url_hash: short_url).limit(1).pluck(:original_url).first
    end

    private
    def generate_hash(original_url)
        hash_num = Digest::SHA1.hexdigest(original_url)[0..15].to_i(16)
        short_code = Base62.encode(hash_num)
        short_code
    end
  end
end
