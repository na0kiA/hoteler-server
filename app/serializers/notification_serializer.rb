# frozen_string_literal: true

class NotificationSerializer < ActiveModel::Serializer
  attributes :id,
             :title,
             :message,
             :kind
  
  def title
    if object.hotel_updates?
      object.hotel.name
    end
  end

  def message
    if object.hotel_updates?
      object.message
    end
  end
end