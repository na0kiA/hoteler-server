# frozen_string_literal: true

class HotelFilter
  attr_reader :hotel_list, :filter_conditions
  private :hotel_list, :filter_conditions

  def initialize(hotel_list:, filter_conditions:)
    @hotel_list = hotel_list
    @filter_conditions = filter_conditions
    @hotels = []
    freeze
  end

  def filter
    filterd_result
  end

  private

    def filterd_result
      filter_conditions.each do |condition|
        @hotels << hotel_list.select { |hotel| hotel.hotel_facility[condition.to_sym] }
      end
      @hotels.flatten.uniq
    end
end
