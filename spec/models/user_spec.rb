# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do

  describe '#attr_accessors' do
    it { is_expected.to have_attr_accessor(:id) }
    it { is_expected.to have_attr_accessor(:email) }
    it { is_expected.to have_attr_accessor(:first_name) }
    it { is_expected.to have_attr_accessor(:last_name) }
    it { is_expected.to have_attr_accessor(:password) }
    it { is_expected.to have_attr_accessor(:current_password) }
    it { is_expected.to have_attr_accessor(:new_password) }
    it { is_expected.to have_attr_accessor(:date_of_birth) }
    it { is_expected.to have_attr_accessor(:image_url) }
    it { is_expected.to have_attr_accessor(:new_record) }
    it { is_expected.to have_attr_accessor(:token) }
    it { is_expected.to have_attr_accessor(:refresh_token) }
    it { is_expected.to have_attr_accessor(:response) }
  end

  describe '#methods' do
    it { is_expected.to respond_to(:save) }
    it { is_expected.to respond_to(:check_email) }
    it { is_expected.to respond_to(:reset_password) }
    it { is_expected.to respond_to(:change_password) }
    it { is_expected.to respond_to(:show_logged_in_user) }
    it { is_expected.to respond_to(:show_user_id) }

    it { is_expected.to respond_to(:get_private_widgets) }
    it { is_expected.to respond_to(:get_widgets_by_user_id) }

    it { is_expected.to respond_to(:authenticate) }
    it { is_expected.to respond_to(:token_refresh) }
    it { is_expected.to respond_to(:token_revoke) }

    it { is_expected.to respond_to(:errors) }
  end

  describe '.save', :vcr do
    context 'when is new record' do
      subject { FactoryBot.build(:new_user).save }

      it { is_expected.to eq true }
    end
    context 'when is existent record' do
      subject { user.save }

      let(:user) { FactoryBot.build(:user, existent: true) }

      before do
        user.first_name = 'Name'
        user.last_name = 'Surname'
      end

      it { is_expected.to eq true }

      it 'updates the user' do
        user.save
        expect(user.response.dig('data', 'user', 'first_name')).to eq 'Name'
        expect(user.response.dig('data', 'user', 'last_name')).to eq 'Surname'
      end

      context 'user is not authenticated' do
        before { user.token = nil }

        it { is_expected.to eq false }
      end
    end
  end

  describe '.check_email', :vcr do
    subject { user.check_email }

    let(:user) { FactoryBot.build(:user) }

    it { is_expected.to eq true }

    context 'when user does not exists' do
      let(:user) { FactoryBot.build(:user) }

      it 'has available email' do
        user.check_email

        expect(user.response.dig('data', 'available')).to eq true
      end
    end

    context 'when user exists' do
      let(:user) { FactoryBot.build(:user, existent: true) }

      it 'has not available email' do
        user.check_email

        expect(user.response.dig('data', 'available')).to eq false
      end
    end
  end

  describe '.reset_password', :vcr do
    subject { user.reset_password }

    let(:user) { FactoryBot.build(:user, existent: true) }

    it { is_expected.to eq true }

    context 'when user does not exist' do
      let(:user) { FactoryBot.build(:user) }

      it { is_expected.to eq false }
    end
  end

  describe '.change_password', :vcr do
    subject { user.change_password }

    let(:user) { FactoryBot.build(:user, existent: true) }

    it { is_expected.to eq true }
    it 'updates user password' do
      user.change_password
      expect(user.authenticate).to eq false
      user.password = user.new_password
      expect(user.authenticate).to eq true
    end

    context 'when user is not authenticated' do
      before { user.token = nil }

      it { is_expected.to eq false }
    end
  end

  describe '.show_logged_in_user', :vcr do
    subject { user.show_logged_in_user }

    let(:user) { FactoryBot.build(:user, existent: true) }

    it { is_expected.to eq true }

    context 'when user is not logged in' do
      before { user.token = nil }

      it { is_expected.to eq false }
    end

    context 'when user does not exist' do
      let(:user) { FactoryBot.build(:user) }

      it { is_expected.to eq false }
    end
  end

  describe '.show_user_id', :vcr do
    subject { user.show_logged_in_user }

    let(:user) { FactoryBot.build(:user, existent: true) }

    it { is_expected.to eq true }

    context 'when user is not logged in' do
      before { user.token = nil }

      it { is_expected.to eq false }
    end

    context 'when user does not exist' do
      let(:user) { FactoryBot.build(:user) }

      it { is_expected.to eq false }
    end
  end

  describe '.get_private_widgets', :vcr do
    subject { user.get_private_widgets }
    let(:user) { FactoryBot.build(:user, existent: true, widgets: 2) }

    it { is_expected.to eq true }
    it 'shows two widgets' do
      user.get_private_widgets

      widgets = user.response.dig('data', 'widgets')

      expect(widgets.size).to eq 2
      expect(widgets.sample['owner']).to eq true
    end

    context 'when user is not authenticated' do
      before { user.token = nil }

      it { is_expected.to eq false }
    end
  end

  describe '.get_widgets_by_user_id', :vcr do
    subject { user.get_widgets_by_user_id }
    let(:user) { FactoryBot.build(:user, existent: true) }

    before do
      FactoryBot.build(:new_widget, :visible, user_token: user.token).save
      FactoryBot.build(:new_widget, :hidden, user_token: user.token).save
    end

    it { is_expected.to eq true }
    it 'shows two widgets' do
      user.get_widgets_by_user_id

      widgets = user.response.dig('data', 'widgets')

      expect(widgets.size).to eq 2
      expect(widgets.sample['owner']).to eq true
    end

    context 'when user is not authenticated' do
      before { user.token = nil }

      it { is_expected.to eq true }
      it 'shows only visible widgets' do
        user.get_widgets_by_user_id

        widgets = user.response.dig('data', 'widgets')

        expect(widgets.size).to eq 1 # visible
        expect(widgets.sample['owner']).to eq false
      end
    end
  end

  describe '.authenticate', :vcr do
    subject { user.authenticate }

    let(:user) { FactoryBot.build(:user, existent: true) }

    it { is_expected.to eq true }

    it 'updates user tokens' do
      expect{ user.authenticate }.to change(user, :token)
      expect{ user.authenticate }.to change(user, :refresh_token)
    end

    context 'when user does not exist' do
      let(:user) { FactoryBot.build(:user) }

      it { is_expected.to eq false }
    end
  end

  describe '.token_refresh', :vcr do
    subject { user.token_refresh }

    let(:user) { FactoryBot.build(:user, existent: true) }

    it { is_expected.to eq true }

    it 'updates user tokens' do
      expect{ user.token_refresh }.to change(user, :token)
      expect{ user.token_refresh }.to change(user, :refresh_token)
    end

    context 'when user is not logged in' do
      before { user.token = user.refresh_token = nil }

      it { is_expected.to eq false }
    end

    context 'when user does not exist' do
      let(:user) { FactoryBot.build(:user) }

      it { is_expected.to eq false }
    end
  end

  describe '.token_revoke', :vcr do
    subject { user.token_revoke }

    let(:user) { FactoryBot.build(:user, existent: true) }

    before { user.authenticate }

    it { is_expected.to eq true }
  end
end
