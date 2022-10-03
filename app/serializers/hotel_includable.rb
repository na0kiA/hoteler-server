# frozen_string_literal: true

module HotelIncludable
  def hotel_includes_by(model:, serializer:)
    case serializer.name
    when 'HotelSerializer'
      model.includes(
        :hotel_images,
        :days,
        days: :rest_rates
      )
    else
      raise StandardError, "Unsupported serializer: #{serializer}"
    end
  end

  # module_function :hotel_includes_by
end
