# frozen_string_literal: true

class HotelFilter
  attr_reader :hotel_list, :filter_conditions
  private :hotel_list, :filter_conditions

  def initialize(hotel_list:, filter_conditions:)
    @hotel_list = hotel_list
    @filter_conditions = filter_conditions
    @hotels = []
  end

  def filter
    filtered_result
  end

  private

    def filtered_result
      @hotels = hotel_list.select do |hotel|
        filter_conditions.all? do |condition|
          hotel.hotel_facility[condition.to_sym]
        end
      end
      @hotels
    end
end
