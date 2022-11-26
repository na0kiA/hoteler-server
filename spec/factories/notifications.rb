# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    trait :with_hotel_updates do
      message { "料金を値下げ致しました。" }
      kind { "hotel_updates" }
    end

    trait :with_read do
      read { true }
    end

    trait :with_user_passive_notifications do
      user_id { create(:user) }
    end
  end
end
