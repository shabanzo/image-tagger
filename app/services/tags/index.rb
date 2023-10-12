# frozen_string_literal: true

module Tags
  # Service for generating Tags#index data
  class Index
    attr_reader :options, :tags

    def initialize(options: {})
      @options = options
    end

    def call
      @tags = tags_query
    end

    private

    def tags_query
      Tag.
        select('tags.id, tags.name, COUNT(image_tags.id) AS total_images').
        left_joins(:image_tags).
        where("tags.name ILIKE COALESCE(?, tags.name)", search_term).
        group('tags.id, tags.name').
        order(sort).
        page(page).
        per(per_page)
    end

    def search_term
      @search_term ||= "%#{options[:keyword]}%" if options[:keyword].present?
    end

    def page
      @page ||= options[:page] || 1
    end

    def per_page
      @per_page ||= options[:per_page] || 10
    end

    def sort
      @sort ||= options[:sort] || 'tags.name ASC'
    end
  end
end
