# frozen_string_literal: true

class TypeDailyRateArray < ActiveModel::Type::Value
  def cast_value(value)
    arr = []
    value.each do |v|
      arr.push Day.new(v)
    end
    arr
  end
end
