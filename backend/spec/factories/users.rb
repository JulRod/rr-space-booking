FactoryBot.define do
  factory :user do
    association :company
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password123' }
    password_confirmation { 'password123' }
    first_name { 'John' }
    last_name { 'Doe' }
    role { :employee }
    active { true }

    trait :admin do
      role { :admin }
    end

    trait :manager do
      role { :manager }
    end

    trait :inactive do
      active { false }
    end

    trait :without_name do
      first_name { nil }
      last_name { nil }
    end
  end
end
