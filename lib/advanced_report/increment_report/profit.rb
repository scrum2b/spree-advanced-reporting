class AdvancedReport::IncrementReport::Profit < AdvancedReport::IncrementReport
  def name
    "Profit"
  end

  def column
    "Profit"
  end

  def description
    "Total profit in orders, where profit is the sum of item quantity times item price minus item cost price"
  end

  def initialize(params)
    super(params)
    self.total = 0
    self.orders.each do |order|
      date = INCREMENTS.inject({}) { |hash, type| hash[type] = get_bucket(type, order.completed_at); hash }
      profit = profit(order)
      INCREMENTS.each { |type| data[type][date[type]][:value] += profit }
      self.total += profit
    end

    generate_ruport_data

    INCREMENTS.each { |type| ruportdata[type].replace_column("Profit") { |r| "$%0.2f" % r["Profit"] } }
  end

  def format_total
    '$' + ((self.total*100).round.to_f / 100).to_s
  end
end
