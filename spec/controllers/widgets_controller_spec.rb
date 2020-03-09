# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WidgetsController, type: :controller do
  let!(:user) { FactoryBot.build(:user, existent: true) }
  let(:widget) { FactoryBot.build(:widget, existent: true, user_token: user.token) }

  let(:valid_attributes) do
    {
        id: widget.id,
        name: FFaker::Name.unique.name, # random name
        description: widget.description,
        kind: widget.kind,
        user_token: user.token
    }
  end

  describe 'GET #index', :vcr do
    it 'returns a success response' do
      get :index, params: {widget: valid_attributes}
      expect(response).to be_successful
    end
  end

  describe 'GET #visible', :vcr do
    it 'returns a success response' do
      get :visible, params: {widget: valid_attributes}
      expect(response).to be_successful
    end

    context 'when search term is present' do
      it 'returns a success response' do
        get :visible, params: {search_term: 'term', widget: valid_attributes}
        expect(response).to be_successful
      end
    end
  end

  describe 'POST #create', :vcr do
    it 'returns a success response' do
      post :create, params: {widget: valid_attributes}
      expect(response).to have_http_status(:redirect)
    end
  end

  describe 'PUT #update', :vcr do
    let(:new_attributes) {
      {
          name: 'New widget name',
          description: 'New widget description'
      }
    }

    it 'returns a success response' do
      put :update, params: {id: widget.id, widget: valid_attributes.merge(new_attributes)}
      expect(response).to be_successful
    end
  end

  describe 'DELETE #destroy', :vcr do
    it 'destroys the requested widget' do
      delete :destroy, params: {id: widget.id, widget: valid_attributes}
      expect(response).to be_successful
    end
  end
end
