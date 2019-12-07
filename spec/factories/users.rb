FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User ##{n}" }
    sequence(:email) { |n| "usr#{n}@example.com" }
  end
end
