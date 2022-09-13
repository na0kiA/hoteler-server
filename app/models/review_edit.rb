class ReviewEdit
  attr_reader :params, :set_review, :key, :title, :content

  def initialize(params:, set_review:)
    @params = params
    @set_review = set_review
    @title = params.fetch(:title)
    @content = params.fetch(:content)
    # @key = params[:key]&.parse_key
    if params[:key].present?
      @key = JSON.parse(params[:key])
    else
      @key = []
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
    Review.update!(set_review.id, title: params[:title], content: params[:content])
  end

  def extract_unnecessary_key
    set_review.review_images.pluck(:key).difference(key)
  end

  def remove_unnecessary_key
    set_review.review_images.where(key: extract_unnecessary_key).delete_all
  end

  def find_or_create_key
    key.each do |val|
      set_review.review_images.find_or_create_by!(key: val)
    end
  end
end