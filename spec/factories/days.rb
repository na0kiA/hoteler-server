# frozen_string_literal: true

FactoryBot.define do
  factory :weekdays, class: 'Day' do
    day { '月曜から木曜' }
  end
  factory :friday, class: 'Day' do
    day { '金曜' }
  end
  factory :saturday, class: 'Day' do
    day { '土曜' }
  end
  factory :sunday, class: 'Day' do
    day { '日曜' }
  end
  factory :holiday, class: 'Day' do
    day { '祝日' }
  end
  factory :special_weeks, class: 'Day' do
    day { '特別期間' }
  end
end
