class ReviewEdit

  attr_reader :set_review, :five_star_rate, :key, :title, :content, :hotel_id

  def initialize(params:, set_review:)
    @set_review = set_review
    @title = params.fetch(:title)
    @content = params.fetch(:content)
    @five_star_rate = params.fetch(:five_star_rate)
    @hotel_id = params.fetch(:hotel_id)
    @key = if params[:key].present?
             JSON.parse(params[:key])
           else
             []
           end
    freeze
  end

  def update
    return if title.blank? || content.blank?

    ActiveRecord::Base.transaction do
      update_review
      remove_unnecessary_key
      find_or_create_key
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def update_review
    Review.update!(set_review.id, title:, content:, five_star_rate:)
  end

  def remove_unnecessary_key
    set_review.review_images.where(key: extract_unnecessary_key).delete_all
  end

  def extract_unnecessary_key
    set_review.review_images.pluck(:key).difference(key)
  end

  def find_or_create_key
    key.each do |val|
      set_review.review_images.find_or_create_by!(key: val)
    end
  end
end
