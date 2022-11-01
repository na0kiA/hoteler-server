# frozen_string_literal: true

class DaySerializer < ActiveModel::Serializer
  attributes :id, :day, :hotel_id
end
