# frozen_string_literal: true

class RestRateSerializer < ActiveModel::Serializer
  attributes :plan, :rate, :first_time, :last_time, :day_id
end
