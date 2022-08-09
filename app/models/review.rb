class Review < ApplicationRecord
  belongs_to :user
  belongs_to :hotel

  validates :title, presence: true, length: { minimum: 5, maximum: 50 }
  validates :content, presence: true, length: { minimum: 10, maximum: 1000 }

  # class << self
  #   def save(params)
  #     Review.create!(title: params[:title], content: params[:content], hotel_id: params[:hotel_id], user_id: params[:user_id])
  #   end
  # end
end
