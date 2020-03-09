# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Widget, type: :model do
  let(:user) { FactoryBot.build(:user, existent: true) }

  describe '#attr_accessors' do
    it { is_expected.to have_attr_accessor(:id) }
    it { is_expected.to have_attr_accessor(:name) }
    it { is_expected.to have_attr_accessor(:description) }
    it { is_expected.to have_attr_accessor(:kind) }
    it { is_expected.to have_attr_accessor(:new_record) }
    it { is_expected.to have_attr_accessor(:user_token) }
    it { is_expected.to have_attr_accessor(:response) }
  end

  describe '#methods' do
    it { is_expected.to respond_to(:save) }
    it { is_expected.to respond_to(:public_widgets) }
    it { is_expected.to respond_to(:visible_widgets) }
    it { is_expected.to respond_to(:errors) }
    it { is_expected.to respond_to(:user) }
  end

  describe '.save', :vcr do
    context 'when is new record' do
      subject { widget.save }

      let(:widget) { FactoryBot.build(:new_widget, user_token: user.token) }

      it { is_expected.to eq true }

      context 'when token is revoked' do
        before { user.token_revoke }

        it { is_expected.to eq false }
      end
    end

    context 'when is not new record (update)' do
      subject { widget.save }

      let(:widget) { FactoryBot.build(:widget, user_token: user.token, existent: true) }

      before do
        widget.name = 'Widget'
        widget.description = 'Description'
      end

      it { is_expected.to eq true }
      it 'updates widget fields' do
        widget.save

        expect(widget.response.dig('data', 'widget', 'name')).to eq 'Widget'
        expect(widget.response.dig('data', 'widget', 'description')).to eq 'Description'
      end

      context 'when token is revoked' do
        before { user.token_revoke }

        it { is_expected.to eq false }
      end
    end
  end

  describe '.delete_widget', :vcr do
    subject { widget.delete_widget }

    let(:widget) { FactoryBot.build(:widget, user_token: user.token, existent: true) }

    before do
      user.authenticate
    end

    it { is_expected.to eq true }
    it 'deletes the widget' do
      widget.delete_widget

      user.private_widgets

      user_widgets = user.response.dig('data', 'widgets')

      expect(user_widgets.map { |e| e['id'] }).not_to include(widget.id)
    end
  end

  describe '.public_widgets', :vcr do
    subject { widget.public_widgets }

    let(:widget) { FactoryBot.build(:widget, user_token: user.token, existent: true) }

    it { is_expected.to eq true }

    context 'when token is revoked' do
      before { user.token_revoke }

      it { is_expected.to eq false }
    end
  end

  describe '.visible_widgets', :vcr do
    subject { widget.visible_widgets }

    let(:widget) { FactoryBot.build(:widget, user_token: user.token, existent: true) }

    it { is_expected.to eq true }
    it 'shows only visible widgets' do
      widget.visible_widgets
      widgets = widget.response.dig('data', 'widgets')
      kinds = widgets.map { |e| e['kind'] }

      expect(kinds.all? { |kind| kind.eql?('visible') }).to eq true
    end
  end
end
