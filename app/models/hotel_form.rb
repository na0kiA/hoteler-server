class HotelForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :hotel, :string
  attribute :name, :string
  attribute :content, :string

  def params
    attributes.deep_symbolize_keys
  end
end