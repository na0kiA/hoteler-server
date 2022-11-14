# frozen_string_literal: true

class ReviewOfTopPage
  attr_reader :date
  private :date

  # 参考になったが多い順に口コミを並べる。
  # 参考になったの数が同じ場合は、review_idの新しい順に並べる

  def initialize(date:)
    @date = date
  end

  def extract_top_reviews
    Review.where(id: sort_by_most_helpful_and_current_review.pluck(0)).take(4)
  end

  private

    def sort_by_most_helpful_and_current_review
      review_id_and_helpsulness_count_array.sort_by { |x| [x[1], x[0]] }.reverse
    end

    def review_id_and_helpsulness_count_array
      Rails.logger.debug date
      date.map do |review|
        [review.id, review.helpfulnesses.count]
      end
    end
end
