require "digest"
require "uri"

class UrlEncoderService
  class << self
    def encode(original_url)
        Url.transaction do
          existing_url = Url.lock.find_by(original_url: original_url)
          return existing_url.url_hash if existing_url

          loop do
              hash = generate_hash(original_url)
              conflict = Url.where(url_hash: hash).limit(1).pluck(:url_hash).first
              next if conflict

              begin
                url = Url.create!(original_url: original_url, url_hash: hash)
                return url.url_hash
              rescue ActiveRecord::RecordNotUnique
                next
              end
          end
        end
    end


    def decode(short_url)
        uri = URI(short_url)
        hash = uri.path.split("/").reject(&:empty?).last
        Url.where(url_hash: hash).limit(1).pluck(:original_url).first
    end

    private
    def generate_hash(original_url)
        hash_num = Digest::SHA1.hexdigest(original_url)[0..15].to_i(16)
        short_code = Base62.encode(hash_num)
        short_code
    end
  end
end
