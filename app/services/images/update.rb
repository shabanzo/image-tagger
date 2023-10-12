# frozen_string_literal: true

module Images
  # Service for update an image
  class Update
    attr_reader :id, :image_params, :image, :success

    def initialize(id:, image_params: {})
      @id = id
      @image_params = image_params
      @success = false
    end

    def call
      find_image
      return unless image.update(image_params)

      update_tags
      image.reload
      @success = true
    end

    private

    def find_image
      @image = Image.find(id)
    end

    def update_tags
      result = Clarifai.new.predict(image_url: image.file.service_url)
      tags_attributes = result['outputs'].first['data']['concepts'].map { |x| { name: x['name'] } }
      new_tags = tags_attributes.map do |tag_attrs|
        # Check if the tag already exists based on some criteria (e.g., name).
        # If it exists, update it; otherwise, create a new one.
        Tag.find_or_initialize_by(name: tag_attrs[:name])
      end
      image.tags = new_tags
      image.save
    end
  end
end
