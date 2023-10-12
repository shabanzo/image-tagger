# frozen_string_literal: true

# Controller for Tags
class ImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_image, only: %i[show edit update destroy]

  # GET /images or /images.json
  def index
    index_ins = Images::Index.new(options: index_params)
    index_ins.call

    @images = index_ins.images
    @top_tags = index_ins.top_tags
  end

  # GET /images/1 or /images/1.json
  def show; end

  # GET /images/new
  def new
    @image = Image.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /images/1/edit
  def edit; end

  # POST /images or /images.json
  def create
    create_ins = Images::Create.new(image_params: image_params)
    create_ins.call

    @image = create_ins.image
    respond_to do |format|
      if create_ins.success
        format.html { redirect_to @image, notice: "Image was successfully created." }
        format.json { render :show, status: :created, location: @image }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /images/1 or /images/1.json
  def update
    update_ins = Images::Update.new(id: params[:id], image_params: image_params)
    update_ins.call

    @image = update_ins.image
    respond_to do |format|
      if update_ins.success
        format.html { redirect_to @image, notice: "Image was successfully updated." }
        format.json { render :show, status: :ok, location: @image }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1 or /images/1.json
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to images_url, notice: "Image was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_image
    @image = Image.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def image_params
    params.require(:image).permit(:name, :file, :description)
  end

  def index_params
    params.permit(:page, :per_page, :sort, :keyword, :tag_id)
  end
end
