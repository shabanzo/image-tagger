# frozen_string_literal: true

require 'rails_helper'

# Unit Test
RSpec.describe Images::Index, type: :service do
  describe '#call' do
    let(:options) { {} }
    let(:service) { described_class.new(options: options) }
    let(:images) { create_list(:image, 2) }

    before do
      create_list(:image_tag, 2, image_id: images.first.id)
      create_list(:image_tag, 3, image_id: images.last.id)
    end

    it 'fetches images and top tags' do
      service.call
      expect(service.images).not_to be_nil
      expect(service.top_tags).not_to be_nil
    end

    context 'when the keyword exists' do
      it 'returns the correct record' do
        expected_image = images.first
        options[:keyword] = expected_image.name
        service.call
        expect(service.images).to be_include(expected_image)
      end
    end

    context 'when the tag_id exists' do
      it 'returns the correct record' do
        expected_image = images.first
        options[:tag_id] = expected_image.tags.first.id
        service.call
        expect(service.images).to be_include(expected_image)
      end
    end
  end
end
