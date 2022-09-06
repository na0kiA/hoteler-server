class HotelForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :content, :string
  attribute :key, :string
  attribute :file_url, :string
  attribute :user_id, :integer

  with_options presence: true do
    with_options invalid_words: true do
      validates :name, length: { maximum: 50 }
      validates :content, length: { minimum: 10, maximum: 2000 }
    end
    validates :key, length: { minimum: 10 }
    validates :file_url, length: { minimum: 10 }
    validates :user_id
  end

  def params
    attributes.deep_symbolize_keys
  end
end