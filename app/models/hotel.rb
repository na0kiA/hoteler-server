class Hotel < ApplicationRecord
  scope :accepted, -> { where(accepted: true) }

  belongs_to :user
  has_many :hotel_images, dependent: :destroy
  has_many :reviews, dependent: :destroy

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
    # 1, callbackでsaveする前に保存されている値をすべて削除してからbuild,saveをする
    # 2, 
    ActiveRecord::Base.transaction do
      hotel = Hotel.update!(set_hotel.id, name: params[:name], content: params[:content])
      JSON.parse(params[:key]).each do |val|
        binding.break
        hotel.hotel_images.build(key: val, file_url: params[:file_url])
        #<HotelImage id: nil, hotel_id: 166, key: "key2001", file_url: "this is file", created_at: nil, updated_at: nil>
        #<HotelImage id: nil, hotel_id: 166, key: "key2002", file_url: "this is file", created_at: nil, updated_at: nil>
      end
    end
  rescue ActiveRecord::RecordInvalid
    false
  end
end
