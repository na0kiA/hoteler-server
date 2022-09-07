class Hotel < ApplicationRecord
  scope :accepted, -> { where(accepted: true) }

  belongs_to :user
  has_many :hotel_images, dependent: :destroy
  has_many :reviews, dependent: :destroy

  # before_create :delete_hotel_images

  def self.save(params)
    ActiveRecord::Base.transaction do
      hotel = Hotel.new(name: params[:name], content: params[:content], user_id: params[:user_id])
      JSON.parse(params[:key]).each do |val|
        hotel.hotel_images.build(key: val, file_url: params[:file_url])
      end
      hotel.save!
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  def self.update(params, set_hotel)
    ActiveRecord::Base.transaction do
      hotel = Hotel.update!(set_hotel.id, name: params[:name], content: params[:content])
      hotel.hotel_images.destroy_all
      JSON.parse(params[:key]).each do |val|
        hotel.hotel_images.build(key: val, file_url: params[:file_url])
      end
      hotel.save!
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  # private

  # def delete_hotel_images
  #   puts  "前回のホテル画像を削除"
  # end
end
