# frozen_string_literal: true

FactoryBot.define do
  factory :review do
    title { "残念でした" }
    content { "部屋が汚かったです" }
    five_star_rate { 1 }

    trait :five_star_rated_review do
      title { "部屋が綺麗でした" }
      content { "また行こうと思っています" }
      five_star_rate { 5 }
    end

    trait :four_star_rated_review do
      title { "よかったです" }
      content { "思ったより安かったです" }
      five_star_rate { 4 }
    end

    trait :three_star_rated_review do
      title { "まあまあでした" }
      content { "思ったより高かったです" }
      five_star_rate { 3 }
    end

    trait :two_star_rated_review do
      title { "部屋が狭かった" }
      content { "写真で見るより部屋が狭い" }
      five_star_rate { 2 }
    end
    
    trait :one_star_rated_review do
      title { "残念" }
      content { "どんどん値上げされている" }
      five_star_rate { 1 }
    end

    # trait :with_a_review_and_helpfulnesses do
    #   after(:build) do |review|
    #     review.helpfulnesses << FactoryBot.build(:review, :five_star_rated_review, :with_five_helpfulness)
        # review.helpfulnesses << FactoryBot.build(:review, :friday, :with_rest_rates, :with_day_off_stay_rates)
        # review.helpfulnesses << FactoryBot.build(:review, :saturday, :with_day_off_rest_rates, :with_day_off_stay_rates)
        # review.helpfulnesses << FactoryBot.build(:review, :sunday, :with_day_off_rest_rates, :with_stay_rates)
        # review.helpfulnesses << FactoryBot.build(:review, :holiday, :with_day_off_rest_rates, :with_stay_rates)
    #   end
    # end
  end
end
