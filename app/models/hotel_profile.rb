# frozen_string_literal: true
# # frozen_string_literal: true

# class HotelProfile
#   include ActiveModel::Model

#   attr_reader :params, :name, :content, :set_hotel, :key, :daily_rates

#   def initialize(params:, set_hotel:)
#     @params = params
#     @name = params.fetch(:name)
#     @content = params.fetch(:content)
#     @key = params.fetch(:key)
#     @daily_rates = params.fetch(:daily_rates)
#     @set_hotel = set_hotel
#   end

#   def update
#     return if invalid?

#     ActiveRecord::Base.transaction do
#       find_or_create_key
#       remove_unnecessary_key
#       update_hotel
#     end
#   rescue ActiveRecord::RecordInvalid
#     false
#   end

#   private

#     def update_hotel
#       Hotel.update!(set_hotel.id, name:, content:)
#     end

    # def difference_key_array
    #   set_hotel.hotel_images.pluck(:key).difference(key)
    # end

    # def find_or_create_key
    #   key.each do |val|
    #     set_hotel.hotel_images.find_or_create_by!(key: val)
    #   end
    # end

    # def remove_unnecessary_key
    #   set_hotel.hotel_images.where(key: difference_key_array).delete_all
    # end
# end
