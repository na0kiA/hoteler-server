# frozen_string_literal: true

require 'holiday_japan'

class RestRateSerializer < ActiveModel::Serializer
  attribute :plan
  attribute :rate
  attribute :first_time do
    convert_at_hour(time: object.first_time)
  end
  attribute :last_time do
    convert_at_hour(time: object.last_time)
  end

  private

    def convert_at_hour(time:)
      (I18n.l time, format: :hours).to_i
    end
end
