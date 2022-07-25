class Hotel < ApplicationRecord
  scope :accepted, -> { where(accepted: true) }

  belongs_to :user
  has_many :images, dependent: :destroy
  validates :name, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 2000 }

  class << self
    def create!(params)
      ActiveRecord::Base.transaction do
      hotel = new(name: params[:name], content: params[:content],user_id: params[:user_id])
      hotel.save!
      images = Image.new(hotel_id: hotel.id, user_id: params[:user_id], hotel_s3_key: params[:images])
      images.save!
      p images
      end
    end
  end

end
