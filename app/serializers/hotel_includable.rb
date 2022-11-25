# frozen_string_literal: true

module HotelIncludable
  def hotel_includes_by(model:, serializer:)
    case serializer.name
    when "HotelIndexSerializer"
      model.includes(
        :hotel_images,
        :days,
        days: %i[rest_rates stay_rates special_periods]
      )
    else
      raise StandardError, "Unsupported serializer: #{serializer}"
    end
  end
end
