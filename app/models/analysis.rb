class Analysis

  attr_reader :result

  def initialize(expenses)
    @expenses = expenses
    @categories = categories
    @result = summary
  end

  def categories
    t = []
    if !@expenses.nil?
      @expenses.each do |expense|
        t << expense.category.id if !t.include?(expense.category.id)
      end
    end
    t
  end

  def summary
    hash = {}
    @categories.each do |category_id|
      total_value = 0
      @expenses.where(category_id: category_id).each do |expense|
        total_value += expense.value
      end
      hash["#{Category.find(category_id).name}"] = total_value.round(1)
    end
    hash
  end

  def total_price
    sum = 0
    @result.each_value do |value|
      sum += value
    end
    sum.round(1)
  end

  def has_expenses?
    !@expenses.empty?
  end

end
