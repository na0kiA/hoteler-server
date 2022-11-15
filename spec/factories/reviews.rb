# frozen_string_literal: true

FactoryBot.define do
  factory :review do
    title { '残念でした' }
    content { '部屋が汚かったです' }
    five_star_rate { 1 }

    transient do
      helpfulnesses_count { 5 }
    end

    # factory :five_star_rated_review, class: 'Review' do
    trait :five_star_rated_review do
      title { '部屋が綺麗でした' }
      content { 'また行こうと思っています' }
      five_star_rate { 5 }

      after(:build) do |review, evaluator|
        review.user_id = FactoryBot.create(:user).id
        review.helpfulnesses << FactoryBot.build_list(:helpfulness, evaluator.helpfulnesses_count)
      end
    end

    trait :four_star_rated_review do
      title { 'よかったです' }
      content { '思ったより安かったです' }
      five_star_rate { 4 }

      after(:build) do |review, evaluator|
        review.user_id = FactoryBot.create(:user).id
        review.helpfulnesses << FactoryBot.build_list(:helpfulness, evaluator.helpfulnesses_count)
      end
    end

    trait :three_star_rated_review do
      title { 'まあまあでした' }
      content { '思ったより高かったです' }
      five_star_rate { 3 }

      after(:build) do |review, evaluator|
        review.user_id = FactoryBot.create(:user).id
        review.helpfulnesses << FactoryBot.build_list(:helpfulness, evaluator.helpfulnesses_count)
      end
    end

    trait :two_star_rated_review do
      title { '部屋が狭かった' }
      content { '写真で見るより部屋が狭い' }
      five_star_rate { 2 }

      after(:build) do |review, evaluator|
        review.user_id = FactoryBot.create(:user).id
        review.helpfulnesses << FactoryBot.build_list(:helpfulness, evaluator.helpfulnesses_count)
      end
    end

    trait :one_star_rated_review do
      title { '残念です' }
      content { 'どんどん値上げされている' }
      five_star_rate { 1 }

      after(:build) do |review, evaluator|
        review.user_id = FactoryBot.create(:user).id
        review.helpfulnesses << FactoryBot.build_list(:helpfulness, evaluator.helpfulnesses_count)
      end
    end
  end
end
