class Expense < ActiveRecord::Base
  belongs_to :category
  belongs_to :user

  attr_accessible :value, :category_id, :description, :user_id

  PER_PAGE = 50
  DATE_FORMAT = "%Y-%m-%d"

  validates :value, presence: true
  validates :category_id, presence: true
  validates :user_id, presence: true

  def date
    self.created_at.strftime(DATE_FORMAT)
  end

  # Using a class method is the preferred way to accept arguments for scopes.
  # These methods will still be accessible on the association objects:

  class << self

    # return array of values of given scope, "values" is Hash instance method
    def costs
      self.all.map { |expense| expense.value }
    end

    # return array of dates of given scope
    def dates
      self.all.map { |expense| expense.created_at.to_date }
    end

    # def paginated(page)
    #   paginate(:page => page, :per_page => PER_PAGE).order('created_at DESC')
    # end

    def time_filter(_start, _end)
      _start = self.first.created_at if _start.empty?
      _end = self.last.created_at if _end.empty?
      where(created_at: _start.._end.to_date.end_of_day)
    end

    def category_and_time_filter(search)
      if search
        expenses = self.time_filter(search[:start_date], search[:end_date]).order(created_at: :desc)
        if !search[:category_id].empty?
          expenses.where(category_id: search[:category_id])
        else
          expenses
        end
      else
        self.order(created_at: :desc)
      end
    end

    private

    def tgb
    end

  end

end
