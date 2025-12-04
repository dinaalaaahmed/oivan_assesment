module UrlHelper
    require "uri"

    def self.valid_url?(url)
      return false if url.blank?

      begin
        uri = URI.parse(url)
        uri.scheme.present? && uri.host.present?
      rescue URI::InvalidURIError
        false
      end
    end
end
