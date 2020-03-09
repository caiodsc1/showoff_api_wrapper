# frozen_string_literal: true

require 'securerandom'

FactoryBot.define do
  factory :user do
    email { "#{SecureRandom.hex}@showoff.ie" }
    password { '12345678' }
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    new_record { false }
    current_password { password }
    new_password { '123456789' }
    image_url {  'https://static.thenounproject.com/png/961-200.png' }

    transient do
      existent { false }
      widgets { 0 }
    end

    trait :new do
      new_record { true }
    end

    after(:build) do |user, eval|
      if eval.existent
        user.new_record = true
        user.save #create
        user.new_record = false
        user.authenticate
      end

      eval.widgets.times do
        widget = FactoryBot.build(:new_widget)
        widget.user_token = user.token
        widget.save
      end
    end

    factory :new_user, traits: [:new]
  end
end
