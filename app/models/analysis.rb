class Analysis

  attr_reader :result

  def initialize(expenses)
    @expenses = expenses
    @categories = categories.uniq
    @result = summary
  end

  def total_price
    @result.values.inject(0) { |accu, n| accu + n }.round(1)
  end

  def has_expenses?
    !@expenses.empty?
  end

  private

  def summary
    hash = {}
    @categories.each do |category_id|
      total_value = @expenses.where(category_id: category_id).inject(0) { |accu, n| accu + n.value }
      hash["#{Category.find(category_id).name}"] = total_value.round(1)
    end
    hash
  end

  def categories
    @expenses.map { |expense| expense.category.id }
  end

end
