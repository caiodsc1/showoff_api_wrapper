FactoryBot.define do
  factory :widget do
    sequence(:name) { |n| "widget-#{n}" }
    description { FFaker::Lorem.sentence }
    kind { ['hidden', 'visible'].sample }
    new_record { false }

    transient do
      existent { false }
    end

    trait :new do
      new_record { true }
    end

    trait :visible do
      kind { 'visible' }
    end

    trait :hidden do
      kind { 'hidden' }
    end

    after(:build) do |widget, eval|
      if eval.existent
        widget.new_record = true
        widget.save #create
        widget.new_record = false
      end
    end

    factory :new_widget, traits: [:new]
  end
end
