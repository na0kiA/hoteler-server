# frozen_string_literal: true

FactoryBot.define do
  factory :helpfulness do
    user_id { FactoryBot.create(:user).id }
  end
end
