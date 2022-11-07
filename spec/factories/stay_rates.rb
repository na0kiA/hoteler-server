FactoryBot.define do
  factory :stay_rate do
    trait :normal_stay_rate do
      plan { '宿泊1部' }
      rate { 5980 }
      start_time { '20:00' }
      end_time { '11:00' }
    end

    trait :long_stay_rate do
      plan { '宿泊2部' }
      rate { 5980 }
      start_time { '23:00' }
      end_time { '15:00' }
    end

    trait :midnight_stay_rate do
      plan { '素泊まり' }
      rate { 3980 }
      start_time { '0:00' }
      end_time { '9:00' }
    end

    factory :day_off_stay_rate, class: 'StayRate' do
      trait :normal_stay_rate do
        plan { '宿泊1部' }
        rate { 12980 }
        start_time { '22:00' }
        end_time { '11:00' }
      end

      trait :midnight_stay_rate do
        plan { '素泊まり' }
        rate { 10980 }
        start_time { '0:00' }
        end_time { '9:00' }
      end
    end

    factory :special_stay_rate, class: 'StayRate' do
      trait :midnight_stay_rate do
        plan { '素泊まり' }
        rate { 10980 }
        start_time { '0:00' }
        end_time { '9:00' }
      end

      trait :normal_stay_rate do
        plan { '宿泊1部' }
        rate { 12980 }
        start_time { '22:00' }
        end_time { '11:00' }
      end
    end
  end
end
