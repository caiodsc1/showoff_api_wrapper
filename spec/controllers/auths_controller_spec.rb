# frozen_string_literal: true

require 'rails_helper'
require 'securerandom'

RSpec.describe AuthsController, type: :controller do
  let(:user) { FactoryBot.build(:user, existent: true) }

  let(:valid_attributes) do
    {
      username: user.email,
      password: user.password,
      token: user.token,
      refresh_token: user.refresh_token
    }
  end

  describe 'GET #create', :vcr do
    it 'returns a success response' do
      post :create, params: { auth: valid_attributes }
      expect(response).to be_successful
    end

    context 'when wrong password' do
      it 'does not return a success response' do
        post :create, params: { auth: valid_attributes.merge({password: 'wrong'}) }
        expect(response).not_to be_successful
      end
    end
  end

  describe 'GET #refresh', :vcr do
    it 'returns a success response' do
      post :refresh, params: { auth: valid_attributes }
      expect(response).to be_successful
    end

    context 'when invalid refresh token' do
      before { user.token_revoke }

      it 'does not return a success response' do
        post :refresh, params: { auth: valid_attributes }
        expect(response).not_to be_successful
      end
    end
  end

  describe 'GET #revoke', :vcr do
    it 'returns a success response' do
      post :revoke, params: { auth: valid_attributes }
      expect(response).to be_successful
    end

    context 'when invalid token' do
      before { user.token_revoke }

      it 'does not return a success response' do
        post :revoke, params: { auth: valid_attributes }
        expect(response).not_to be_successful
      end
    end
  end
end
