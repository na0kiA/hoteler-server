class ReviewEdit
  attr_reader :params, :set_review

  def initialize(params:, set_review:)
    @params = params
    @set_review = set_review
    freeze
  end

  def update
    ActiveRecord::Base.transaction do
      Review.update!(set_review.id, title: params[:title], content: params[:content])
      remove_unnecessary_key(params, set_review)
      find_or_create_key(params, set_review)
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def remove_unnecessary_key(params, set_review)
    set_review.review_images.pluck(:key).difference(JSON.parse(params[:key])).each do |val|
      set_review.review_images.delete_by!(key: val)
    end
  end

  def find_or_create_key(params, set_review)
    JSON.parse(params[:key]).each do |val|
      set_review.review_images.find_or_create_by!(key: val, file_url: params[:file_url])
    end
  end
end