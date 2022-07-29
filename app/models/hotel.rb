class Hotel < ApplicationRecord
  scope :accepted, -> { where(accepted: true) }

  belongs_to :user
  has_many :images, dependent: :destroy
  validates :name, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 2000 }

  class << self
    def create!(params)
      ActiveRecord::Base.transaction do
        hotel = new(name: params[:name], content: params[:content], user_id: params[:user_id])
        if hotel.valid?
          hotel.save!
        else
          raise "ホテルフォームに誤りがあります"
        end
        # rescue ActiveRecord::StatementInvalid
        images = Image.new(hotel_id: hotel.id, user_id: params[:user_id], hotel_s3_key: params[:images])
        if images.valid?
          images.save!
        else
          raise "ホテルフォームに誤りがあります"
        end
      end
    end
  end
end