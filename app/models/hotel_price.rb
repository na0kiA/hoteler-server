class HotelPrice
  attr_reader :price
  def initialize(price)
    @price = typed_cost(price)
  end

  # ホテルのルーム料金とサービス料と消費税の合計を算出するメソッド
  def total_cost
    price.map do |cost|
      ((cost.room + cost.service) * 1.1).floor
    end
  end

  Cost = Struct.new(:room, :service)
  def typed_cost(price)
    price.map { |cost|
      Cost.new(cost[0], cost[1])}
  end
end