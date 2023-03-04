# frozen_string_literal: true

class StayRateSerializer < ActiveModel::Serializer
  attribute :id
  attribute :plan
  attribute :rate
  attribute :start_time do
    convert_at_hour(time: object.start_time)
  end
  attribute :end_time do
    convert_at_hour(time: object.end_time)
  end
  attribute :service do
    "宿泊"
  end
  attribute :day do
    object.day.day
  end
  attribute :service_id do
    object.id
  end
  attribute :day_id do
    object.day.id
  end

  private

    def convert_at_hour(time:)
      (I18n.l time, format: :hours).to_i
    end
end
