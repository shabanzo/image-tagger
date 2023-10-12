# frozen_string_literal: true

require 'rails_helper'

# Unit Test
RSpec.describe Tags::Index, type: :service do
  let(:options) { {} }
  let(:service) { described_class.new(options: options) }

  let(:tags) { create_list(:tag, 2) }

  before do
    tags
    create(:image_tag, tag: tags.first)
  end

  describe '#call' do
    it 'returns a list of tags' do
      service.call

      expect(service.tags).to be_an(ActiveRecord::Relation)
      expect(service.tags.to_a.size).to eq(2)
    end

    it 'returns total_counts correctly' do
      service.call

      expect(service.tags).to be_an(ActiveRecord::Relation)
      expect([
        service.tags.first.total_images,
        service.tags.last.total_images
      ].max).to eq(1)
    end

    context 'when the keyword exists' do
      it 'returns the correct record' do
        expected_tag = tags.first
        options[:keyword] = expected_tag.name
        service.call

        expect(service.tags.map(&:id)).to include(expected_tag.id)
      end
    end
  end
end
