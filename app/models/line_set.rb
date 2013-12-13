class LineSet

  attr_reader :date, :expenses

  def initialize(date, expenses)
    @date = date
    @expenses = find_expenses(expenses)
  end

  def total_price
    sum = 0
    @expenses.each do |expense|
      sum += expense.value
    end
    sum.round(1)
  end

  private

  def find_expenses(expenses)
    expenses.where('created_at >= :start_date AND created_at <= :end_date',
             start_date: @date.to_datetime,
             end_date: @date.to_datetime.end_of_day)
  end

end
