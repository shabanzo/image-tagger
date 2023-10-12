# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Images::Create, type: :service do
  let(:image_params) { attributes_for(:image) }
  let(:service) { described_class.new(image_params: image_params) }
  let(:expected_response) do
    { outputs: [
        {
          data: {
            concepts: [
              { name: 'Tag1' },
              { name: 'Tag2' },
              { name: 'Tag3' }
            ]
          }
        }
      ],
      success: 10_000 }
  end

  describe '#call' do
    context 'when image creation fails' do
      it 'does not create tags' do
        # Simulate a failure in image creation by passing invalid image params
        invalid_params = image_params.merge(name: nil)
        service = described_class.new(image_params: invalid_params)

        expect {
          service.call
        }.not_to change(Image, :count)

        expect(service.success).to be_falsey
      end
    end
  end
end
