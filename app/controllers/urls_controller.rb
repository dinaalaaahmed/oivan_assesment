class UrlsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :encode, :decode ]
  before_action :validate_url, only: [ :encode, :decode ]

  def encode
    original_url = encode_decode_params[:url]

    encoded = UrlEncoderService.encode(original_url)
    short_url = "#{request.base_url}/#{encoded}"
    render json: { original_url: original_url, short_url: short_url }
  end

  def decode
    short_url = encode_decode_params[:url]

    original_url = UrlEncoderService.decode(short_url)

    if original_url
      render json: { original_url: original_url, short_url: short_url }
    else
      render json: { error: "Invalid URL" }, status: :unprocessable_content
    end
  end

  private

  def encode_decode_params
    params.permit(:url)
  end

  def validate_url
    unless UrlHelper.valid_url?(params[:url])
      render json: { error: "url attribute is not a Valid URL" }, status: :unprocessable_entity
    end
  end
end
