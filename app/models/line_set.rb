class LineSet

  attr_reader :date, :expenses

  def initialize(date, expenses)
    @date = date
    @expenses = find_expenses(expenses)
  end

  def total_price
    @expenses.costs.inject(0) { |v, n| v + n }.round(1)
  end

  private

  def find_expenses(expenses)
    expenses.where(created_at: @date.to_datetime..@date.to_datetime.end_of_day)
  end

end
