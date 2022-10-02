# frozen_string_literal: true

class DaySerializer < ActiveModel::Serializer
  attributes :id, :day, :rest_rates

  def rest_rates
    Day.includes(:rest_rates)
  end
end