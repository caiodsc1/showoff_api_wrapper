# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User::Image, type: :model do
  describe '#attr_accessors' do
    it { is_expected.to have_attr_accessor(:small_url) }
    it { is_expected.to have_attr_accessor(:medium_url) }
    it { is_expected.to have_attr_accessor(:large_url) }
    it { is_expected.to have_attr_accessor(:original_url) }
  end
end
