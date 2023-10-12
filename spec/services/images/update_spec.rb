# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Images::Update do
  let(:image) { create(:image) }
  let(:valid_image_params) { attributes_for(:image, name: 'Updated Name') }

  describe '#call' do
    before do
      allow_any_instance_of(Clarifai).to receive(:predict).and_return(
        'outputs' => [{
          'data' => {
            'concepts' => [
              { 'name' => 'Tag1' },
              { 'name' => 'Tag2' }
            ]
          }
        }]
      )
    end

    context 'with invalid image params' do
      let(:invalid_image_params) { attributes_for(:image, name: nil) }

      it 'does not update the image' do
        service = described_class.new(id: image.id, image_params: invalid_image_params)
        expect(service.call).to be_falsey
        image.reload
        expect(image.name).not_to be_nil
      end

      it 'does not update tags' do
        service = described_class.new(id: image.id, image_params: invalid_image_params)
        expect(service.call).to be_falsey
        image.reload
        expect(image.tags.pluck(:name)).not_to include('Tag1', 'Tag2')
      end
    end
  end
end
