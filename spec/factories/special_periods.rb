# frozen_string_literal: true

FactoryBot.define do
  factory :special_period do
    periods { 1 }
    start_date { '5月2日' }
    end_date { '5月10日' }
  end
end
