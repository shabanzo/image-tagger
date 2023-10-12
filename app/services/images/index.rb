# frozen_string_literal: true

module Images
  # Service for fetching Images#index data
  class Index
    attr_reader :options, :images, :top_tags

    def initialize(options: {})
      @options = options
    end

    def call
      @images = images_query
      @top_tags = top_tags_query
    end

    private

    def images_query
      images_query = Image.
                     left_joins(:tags).
                     includes(:image_tags).
                     includes(:file_attachment).
                     where("images.name ILIKE COALESCE(?, images.name)", search_term).
                     distinct

      images_query = images_query.where(tags: { id: tag_id }) if tag_id.present?

      images_query.order(sort).page(page).per(per_page)
    end

    def top_tags_query
      Tag.
        select('tags.id, tags.name, COUNT(image_tags.id) AS total_images').
        left_joins(:image_tags).
        group('tags.id, tags.name').
        order('total_images DESC').
        limit(4)
    end

    def search_term
      @search_term ||= "%#{options[:keyword]}%" if options[:keyword].present?
    end

    def tag_id
      @tag_id ||= options[:tag_id].present? && options[:tag_id] != 0 ? options[:tag_id] : nil
    end

    def page
      @page ||= options[:page] || 1
    end

    def per_page
      @per_page ||= options[:per_page] || 10
    end

    def sort
      @sort ||= options[:sort] || 'images.name ASC'
    end
  end
end
