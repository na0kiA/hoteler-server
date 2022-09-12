class HotelProfile
  attr_reader :params, :set_hotel, :key

  def initialize(params:, set_hotel:)
    @params = params
    @set_hotel = set_hotel
    @key = JSON.parse(params[:key])
    freeze
  end

  def update
    ActiveRecord::Base.transaction do
      update_hotel
      find_or_create_key
      remove_unnecessary_key
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def update_hotel
    Hotel.update!(set_hotel.id, name: params[:name], content: params[:content])
  end

  def difference_key_array
    set_hotel.hotel_images.pluck(:key).difference(key)
  end

  def remove_unnecessary_key
    set_hotel.hotel_images.where(key: difference_key_array).delete_all
  end

  def find_or_create_key
    key.each do |val|
      set_hotel.hotel_images.find_or_create_by!(key: val, file_url: params[:file_url])
    end
  end
end