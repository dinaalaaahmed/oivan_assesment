class UrlsController < ApplicationController
  def encode
    original_url = encode_params[:original_url]
    encoded = UrlEncoderService.encode(original_url)

    render json: { original_url: original_url, encoded_url: encoded }
  end

  def decode
    decoded = UrlEncoderService.decode(decode_params[:url_hash])

    if decoded
      render json: { original_url: decoded }
    else
      render json: { error: 'Invalid URL' }, status: :unprocessable_entity
    end
  end



  def encode_params
    params.require(:url).permit(:original_url)
  end


  def decode_params
    params.require(:url_hash)
  end
end
