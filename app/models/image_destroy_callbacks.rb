class ImageDestroyCallbacks
  def self.before_create(hotel_form)
    puts "name is #{hotel_form.name}"
  end
end