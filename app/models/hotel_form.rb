class HotelForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  # attribute :hotel, :string
  attribute :name, :string
  attribute :content, :string
  attribute :images
  attribute :user_id, :integer
  # attribute :hotel_id, :integer
  # attribute :hotel_s3_key, :string

  def params
    attributes.deep_symbolize_keys
  end
end