# frozen_string_literal: true

require 'rails_helper'

# Unit Test
RSpec.describe Tags::Show, type: :service do
  let(:options) { {} }
  let(:tag) { create(:tag) }
  let(:service) { described_class.new(options: options) }

  let(:images) { create_list(:image, 2) }

  before do
    create(:image_tag, image_id: images.first.id, tag_id: tag.id)
    create(:image_tag, image_id: images.last.id, tag_id: tag.id)
  end

  describe '#call' do
    it 'finds the specified tag' do
      options[:id] = tag.id
      service.call

      expect(service.tag).to eq(tag)
    end

    it 'returns a list of images for the tag' do
      options[:id] = tag.id
      service.call

      expect(service.images).to be_an(ActiveRecord::Relation)
      expect(service.images.to_a.size).to eq(2)
    end

    context 'when the keyword exists' do
      it 'returns the correct images' do
        expected_image = images.first
        options[:id] = tag.id
        options[:keyword] = expected_image.name
        service.call

        expect(service.images.map(&:id)).to include(expected_image.id)
      end
    end

    context 'when custom sorting is applied' do
      it 'sorts the images correctly' do
        images.first.update(name: 'B')
        images.last.update(name: 'A')
        options[:id] = tag.id
        options[:sort] = 'images.name DESC'

        service.call

        expect(service.images.map(&:name)).to eq(%w[B A])
      end
    end
  end
end
