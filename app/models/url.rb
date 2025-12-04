class Url < ApplicationRecord
    validate :original_url_must_be_valid

    private

    def original_url_must_be_valid
      unless UrlHelper.valid_url?(original_url)
        errors.add(:original_url, "is not a valid URL")
      end
    end
end
