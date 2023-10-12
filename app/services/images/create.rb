# frozen_string_literal: true

module Images
  # Service for created an image
  class Create
    attr_reader :image_params, :image, :success

    def initialize(image_params: {})
      @image_params = image_params
      @success = false
    end

    def call
      @image = Image.new(image_params)
      return unless image.save

      create_tags
      image.reload
      @success = true
    end

    private

    def create_tags
      result = Clarifai.new.predict(image_url: image.file.service_url)
      tags_attributes = result['outputs'].first['data']['concepts'].map { |x| { name: x['name'] } }
      tags_attributes.each do |tag_attrs|
        # Check if the tag already exists based on some criteria (e.g., name).
        # If it exists, update it; otherwise, create a new one.
        tag = Tag.find_or_initialize_by(name: tag_attrs[:name])

        # Associate the image with the tag
        image.tags << tag
      end
      image.save
    end
  end
end
