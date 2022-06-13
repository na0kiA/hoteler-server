FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@gmail.com" }
    sequence(:password) { |n| "test#{n}111" }
    sequence(:password_confirmation) { |n| "test#{n}111" }
  end
end
