# frozen_string_literal: true

FactoryBot.define do
  factory :day do
    day { '月曜から木曜' }
    association :hotel, factory: :completed_profile_hotel
  end
  factory :weekdays, class: 'Day' do
    day { '月曜から木曜' }
    association :hotel, factory: :completed_profile_hotel
  end
  factory :friday, class: 'Day' do
    day { '金曜' }
    association :hotel, factory: :completed_profile_hotel
  end
  factory :saturday, class: 'Day' do
    day { '土曜' }
    association :hotel, factory: :completed_profile_hotel
  end
  factory :sunday, class: 'Day' do
    day { '日曜' }
    association :hotel, factory: :completed_profile_hotel
  end
  factory :holiday, class: 'Day' do
    day { '祝日' }
    association :hotel, factory: :completed_profile_hotel
  end
  factory :special_days, class: 'Day' do
    day { '特別期間' }
    association :hotel, factory: :completed_profile_hotel
  end
end
