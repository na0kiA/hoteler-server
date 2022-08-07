class HotelForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :content, :string
  attribute :user_id, :integer
  attribute :key, :string
  attribute :file_url, :string

  with_options presence: true do
    validates :user_id
    validates :name, length: { maximum: 50 }
    validates :content, length: { minimum: 10, maximum: 2000 }
    validates :key
    validates :file_url
  end

  def save(params)
    hotel = Hotel.create!(name: params[:name], content: params[:content], user_id: params[:user_id])
    HotelImage.create!(hotel_id: hotel.id, key: params[:key], file_url: params[:file_url])
  end
end
