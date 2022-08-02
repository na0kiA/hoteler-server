class HotelForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :content, :string
  # attribute :hotel_s3_key, :string
  attribute :images
  attribute :user_id, :integer
  
  with_options presence: true do
    validates :images
    validates :user_id
  end

  validates :name, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { minimum: 10, maximum: 2000 }

  def params
    attributes.deep_symbolize_keys
  end
end
