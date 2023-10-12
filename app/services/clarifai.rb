# frozen_string_literal: true

# Blueprint for Clarifai instance
class Clarifai
  BASE_URL = 'https://api.clarifai.com/v2'
  PAT = ENV['CLARIFAI_PAT'].freeze
  USER_ID = ENV['CLARIFAI_USER_ID'].freeze
  APP_ID = ENV['CLARIFAI_APP_ID'].freeze
  MODEL_ID = ENV['CLARIFAI_MODEL_ID'].freeze

  def initialize
    @http = setup_http_client
  end

  # For predicting the image
  PREDICT_URL = "#{BASE_URL}/users/#{USER_ID}/apps/#{APP_ID}/models/#{MODEL_ID}/outputs"
  def predict(image_url:)
    request = setup_predict_request(image_url)
    response = @http.request(request)
    JSON.parse(response.body)
  end

  private

  def headers
    @headers ||= {
      Authorization:  "Bearer #{PAT}",
      'Content-Type': 'application/json'
    }
  end

  def setup_http_client
    http = Net::HTTP.new(predict_uri.host, predict_uri.port)
    http.use_ssl = true
    http
  end

  def setup_predict_request(image_url)
    request = Net::HTTP::Post.new(predict_uri.path, headers)
    request.body = predict_body(image_url)
    request
  end

  def predict_uri
    @predict_uri ||= URI(PREDICT_URL)
  end

  def predict_body(image_url)
    { inputs: [{
      data: {
        image: {
          url: image_url
        }
      }
    }] }.to_json
  end
end
