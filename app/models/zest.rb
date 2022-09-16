class Shop
  attr_reader :food, :drink

  def initialize(food, drink)
    @food = food
    @drink = drink
    freeze
  end
  @food = 'sushi'
end
