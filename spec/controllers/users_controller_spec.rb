# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:user) { FactoryBot.build(:user, existent: true) }

  let(:valid_attributes) do
    {
      id: user.id,
      email: user.email,
      first_name: user.first_name,
      last_name: user.last_name,
      password: user.password,
      current_password: user.current_password,
      new_password: user.new_password,
      token: user.token,
      widgets: { search_term: 'term' }
    }
  end

  let(:valid_session) { {} }

  describe 'POST #create', :vcr do
    let(:user) { FactoryBot.build(:user, existent: false) }
    it 'returns a success response' do
      post :create, params: { user: valid_attributes }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'PUT #update', :vcr do
    let(:new_attributes) {
      {
          first_name: 'New name',
          last_name: 'New last name'
      }
    }
    before { valid_attributes.merge!(new_attributes) }

    it 'returns a success response' do
      put :update, params: { id: user.id, user: valid_attributes }, session: valid_session
      expect(response).to be_successful
    end

    context 'when user is not logged in' do
      before { user.token_revoke }

      it 'does not return success response' do
        put :update, params: { id: user.id, user: valid_attributes }, session: valid_session
        expect(response).not_to be_successful
      end
    end
  end

  describe 'POST #show_logged_in_user', :vcr do
    it 'returns a success response' do
      post :show_logged_in_user, params: { user: valid_attributes }, session: valid_session
      expect(response).to be_successful
    end

    context 'when user is not logged in' do
      before { user.token_revoke }

      it 'does not return success response' do
        post :show_logged_in_user, params: { user: valid_attributes }, session: valid_session
        expect(response).not_to be_successful
      end
    end
  end

  describe 'POST #show_user_id', :vcr do
    it 'returns a success response' do
      post :show_user_id, params: { id: user.id, user: valid_attributes }, session: valid_session
      expect(response).to be_successful
    end

    context 'when user is not logged in' do
      before { user.token_revoke }

      it 'does not return success response' do
        put :show_user_id, params: { id: user.id, user: valid_attributes }, session: valid_session
        expect(response).not_to be_successful
      end
    end
  end

  describe 'POST #change_password', :vcr do
    it 'returns a success response' do
      post :change_password, params: { user: valid_attributes }, session: valid_session
      expect(response).to be_successful
    end

    context 'when user is not logged in' do
      before { user.token_revoke }

      it 'does not return success response' do
        post :change_password, params: { id: user.id, user: valid_attributes }, session: valid_session
        expect(response).not_to be_successful
      end
    end
  end

  describe 'POST #reset_password', :vcr do
    it 'returns a success response' do
      post :reset_password, params: { user: valid_attributes }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'POST #check_email', :vcr do
    it 'returns a success response' do
      post :check_email, params: { user: valid_attributes }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'POST #get_private_widgets', :vcr do
    it 'returns a success response' do
      post :get_private_widgets, params: { user: valid_attributes }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'POST #get_widgets_by_user_id', :vcr do
    it 'returns a success response' do
      post :get_widgets_by_user_id, params: { id: user.id, user: valid_attributes }, session: valid_session
      expect(response).to be_successful
    end
  end
end
