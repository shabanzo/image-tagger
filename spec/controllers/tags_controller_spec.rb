# frozen_string_literal: true

require 'rails_helper'

# Integration Test
RSpec.describe TagsController do
  let(:tags) { create_list(:tag, 2) }
  let(:user) { create(:user) }

  before do
    sign_in user
    tags
  end

  describe 'GET #index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'assigns @tags with tag data' do
      get :index

      expect(assigns(:tags)).to include(tags.first, tags.last)
    end
  end

  describe 'GET #show' do
    it 'renders the show template' do
      tag = create(:tag)
      get :show, params: { id: tag.id }
      expect(response).to render_template(:show)
    end

    it 'assigns @tag with the specified tag' do
      tag = create(:tag)
      get :show, params: { id: tag.id }

      expect(assigns(:tag)).to eq(tag)
    end

    it 'assigns @images with images associated with the tag' do
      tag = create(:tag)
      create_list(:image_tag, 2, tag: tag)
      get :show, params: { id: tag.id }

      expect(assigns(:images)).to match_array(tag.images)
    end
  end

  describe 'GET #new' do
    it 'responds with success' do
      get :new
      expect(response).to have_http_status(:success)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:valid_params) { { tag: attributes_for(:tag) } }

      it 'creates a new tag' do
        expect {
          post :create, params: valid_params
        }.to change(Tag, :count).by(1)
      end

      it 'redirects to the created tag' do
        post :create, params: valid_params
        expect(response).to redirect_to(Tag.last)
      end

      it 'sets a success notice' do
        post :create, params: valid_params
        expect(flash[:notice]).to eq('Tag was successfully created.')
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { { tag: attributes_for(:tag, name: nil) } }

      it 'does not create a new tag' do
        expect {
          post :create, params: invalid_params
        }.not_to change(Tag, :count)
      end

      it 'renders the new template' do
        post :create, params: invalid_params
        expect(response).to render_template(:new)
      end
    end
  end
end
