# frozen_string_literal: true

class ReviewOfTopPage
  attr_reader :reviews_of_a_hotel
  private :reviews_of_a_hotel

  # 参考になったが多い順に口コミを並べる。
  # 参考になったの数が同じ場合は、review_idの新しい順に並べる

  def initialize(reviews_of_a_hotel:)
    @reviews_of_a_hotel = Review.preload(:user, :helpfulnesses).where(id: reviews_of_a_hotel.ids)
  end

  def extract_top_reviews
    Review.where(id: sort_by_most_helpful_and_current_review.pluck(0))
  end

  private

    def sort_by_most_helpful_and_current_review
      review_id_and_helpsulness_count_array.sort_by { |x| [x[1], x[0]] }.reverse.take(4)
    end

    def review_id_and_helpsulness_count_array
      reviews_of_a_hotel.map do |review|
        [review.id, review.helpfulnesses_count]
      end
    end
end
