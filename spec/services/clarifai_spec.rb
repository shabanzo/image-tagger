# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Clarifai do
  let(:body_json) { '{"result": "some result"}' }

  describe '#predict' do
    let(:image_url) { 'https://example.com/image.jpg' }
    let(:mock_http_client) do
      instance_double(
        Net::HTTP,
        request: mock_response
      )
    end
    let(:mock_http_post) do
      instance_double(
        Net::HTTP::Post
      )
    end
    let(:mock_response) do
      instance_double(
        Net::HTTPResponse,
        body: body_json
      )
    end
    let(:predict_uri) do
      URI(
        described_class::PREDICT_URL
      )
    end
    let(:headers) do
      {
        Authorization:  "Bearer #{described_class::PAT}",
        'Content-Type': 'application/json'
      }
    end

    before do
      allow(Net::HTTP).to receive(:new).
        with(predict_uri.host, predict_uri.port).
        and_return(mock_http_client)

      allow(mock_http_client).to receive(:use_ssl=).with(true)

      allow(Net::HTTP::Post).to receive(:new).with(
        predict_uri.path, headers
      ).and_return(mock_http_post)

      allow(mock_http_post).to receive(:body=).with("{\"inputs\":[{\"data\":{\"image\":{\"url\":\"#{image_url}\"}}}]}")
      allow(mock_http_client).to receive(:request).with(mock_http_post).and_return(mock_response)
    end

    it 'sends a predict request to Clarifai and parses the response' do
      clarifai = described_class.new
      result = clarifai.predict(image_url: image_url)

      expect(result).to eq(JSON.parse(body_json))
    end
  end
end
