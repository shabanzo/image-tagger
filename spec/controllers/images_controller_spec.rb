# frozen_string_literal: true

require 'rails_helper'

# Integration Test
RSpec.describe ImagesController do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end

    context 'when searching for images' do
      let!(:image) { create(:image, name: 'Sample Image') }

      it 'assigns @images based on the search keyword' do
        get :index, params: { keyword: 'Sample' }
        expect(assigns(:images)).to include(image)
      end
    end
  end

  describe 'GET #show' do
    let(:image) { create(:image) }

    it 'returns a successful response' do
      get :show, params: { id: image.id }
      expect(response).to have_http_status(:success)
    end

    it 'renders the show template' do
      get :show, params: { id: image.id }
      expect(response).to render_template(:show)
    end

    it 'assigns @image' do
      get :show, params: { id: image.id }
      expect(assigns(:image)).to eq(image)
    end
  end

  describe 'GET #new' do
    it 'returns a successful response' do
      get :new
      expect(response).to have_http_status(:success)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'assigns a new @image' do
      get :new
      expect(assigns(:image)).to be_a_new(Image)
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) { attributes_for(:image) }

    context 'with valid params' do
      let(:create_service) { instance_double(Images::Create, call: true, image: create(:image), success: true) }

      before do
        allow(Images::Create).to receive(:new).and_return(create_service)
      end

      it 'redirects to the created image' do
        post :create, params: { image: valid_attributes }
        expect(response).to redirect_to(Image.last)
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) { attributes_for(:image, name: nil) }

      it 'does not create a new Image' do
        expect {
          post :create, params: { image: invalid_attributes }
        }.not_to change(Image, :count)
      end

      it 're-renders the "new" template' do
        post :create, params: { image: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    let(:image) { create(:image) }

    it 'returns a successful response' do
      get :edit, params: { id: image.id }
      expect(response).to have_http_status(:success)
    end

    it 'renders the edit template' do
      get :edit, params: { id: image.id }
      expect(response).to render_template(:edit)
    end

    it 'assigns @image' do
      get :edit, params: { id: image.id }
      expect(assigns(:image)).to eq(image)
    end
  end

  describe 'PATCH #update' do
    let(:image) { create(:image) }

    context 'with valid params' do
      let(:valid_image_params) { attributes_for(:image, name: 'Updated Name') }

      it 'redirects to the image' do
        update_service = instance_double(Images::Update, call: true, image: image, success: true)
        allow(Images::Update).to receive(:new).and_return(update_service)

        patch :update, params: { id: image.id, image: valid_image_params }
        expect(response).to redirect_to(image)
      end
    end

    context 'with invalid params' do
      let(:invalid_image_params) { attributes_for(:image, name: nil) }

      it 're-renders the "edit" template' do
        update_service = instance_double(Images::Update, call: true, image: image, success: false)
        allow(Images::Update).to receive(:new).and_return(update_service)

        patch :update, params: { id: image.id, image: invalid_image_params }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:image) { create(:image) }

    it 'destroys the requested image' do
      expect {
        delete :destroy, params: { id: image.id }
      }.to change(Image, :count).by(-1)
    end

    it 'redirects to the images list' do
      delete :destroy, params: { id: image.id }
      expect(response).to redirect_to(images_url)
    end
  end
end
