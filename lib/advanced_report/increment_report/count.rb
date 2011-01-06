class AdvancedReport::IncrementReport::Count < AdvancedReport::IncrementReport
  def name
    "Order Count"
  end

  def column
    "Count"
  end

  def description
    "Total number of completed orders"
  end

  def initialize(params)
    super(params)
    self.total = 0
    self.orders.each do |order|
      date = INCREMENTS.inject({}) { |hash, type| hash[type] = get_bucket(type, order.completed_at); hash }
      order_count = order_count(order)
      INCREMENTS.each { |type| data[type][date[type]][:value] += order_count }
      self.total += order_count
    end

    generate_ruport_data
  end
end
