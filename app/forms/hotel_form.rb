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

  def save(params)
    return if invalid?

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

  def params
    attributes.deep_symbolize_keys
  end
end