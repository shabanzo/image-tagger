# frozen_string_literal: true

module Tags
  # Service for fetching Tags#show data
  class Show
    attr_reader :options, :tag, :images

    def initialize(options: {})
      @options = options
    end

    def call
      @tag = find_tag
      @images = images_query
    end

    private

    def find_tag
      Tag.find(options[:id])
    end

    def images_query
      tag.images.
        where("images.name ILIKE COALESCE(?, images.name)", search_term).
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
      @sort ||= options[:sort] || 'images.name ASC'
    end
  end
end
