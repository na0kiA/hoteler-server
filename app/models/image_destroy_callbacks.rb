class ImageDestroyCallbacks
  def self.before_create(hotel_form)
    Rails.logger.debug { "name is #{hotel_form.name}" }
  end
end
