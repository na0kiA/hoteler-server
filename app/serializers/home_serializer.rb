# frozen_string_literal: true

class HomeSerializer < ActiveModel::Serializer
  attributes :hotel

  def hotel
    Hotel.last
  end
end
