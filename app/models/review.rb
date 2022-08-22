class Review < ApplicationRecord
  belongs_to :user
  belongs_to :hotel
  has_many :helpfulnesses, dependent: :destroy

  with_options invalid_words: true do
    with_options presence: true do
      validates :title, length: { minimum: 2, maximum: 1000 }
      validates :content, length: { minimum: 10, maximum: 1000 }
    end
  end

  class << self
    def save(params)
      hotel = Hotel.accepted.find(params[:hotel_id])
      hotel.reviews.create!(title: params[:title], content: params[:content], user_id: params[:user_id])
    end
  end
end
