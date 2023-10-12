# frozen_string_literal: true

# Controller for Tags
class TagsController < ApplicationController
  before_action :authenticate_user!

  # GET /tags or /tags.json
  def index
    index_ins = Tags::Index.new(options: index_params)
    index_ins.call
    @tags = index_ins.tags
  end

  # GET /tags/1 or /tags/1.json
  def show
    show_ins = Tags::Show.new(options: show_params)
    show_ins.call
    @tag = show_ins.tag
    @images = show_ins.images
  end

  # GET /tags/new
  def new
    @tag = Tag.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /tags or /tags.json
  def create
    @tag = Tag.new(tag_params)

    respond_to do |format|
      if @tag.save
        format.html { redirect_to @tag, notice: "Tag was successfully created." }
        format.json { render :show, status: :created, location: @tag }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def tag_params
    params.require(:tag).permit(:name)
  end

  def index_params
    params.permit(:page, :per_page, :sort, :keyword)
  end

  def show_params
    params.permit(:page, :per_page, :sort, :keyword, :id)
  end
end
