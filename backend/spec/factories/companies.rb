FactoryBot.define do
  factory :company do
    sequence(:subdomain) { |n| "company#{n}" }
    sequence(:name) { |n| "Company #{n}" }
    active { true }

    trait :inactive do
      active { false }
    end

    trait :with_settings do
      settings { { theme: 'light', timezone: 'UTC' } }
    end
  end
end
