# frozen_string_literal: true

require 'holiday_japan'

class RestRateSerializer < ActiveModel::Serializer
  attribute :plan
  attribute :rate
  attribute :start_time do
    convert_at_hour(time: object.start_time)
  end
  attribute :end_time do
    convert_at_hour(time: object.end_time)
  end

  private

    def convert_at_hour(time:)
      (I18n.l time, format: :hours).to_i
    end
end
