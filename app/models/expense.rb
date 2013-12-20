class Expense < ActiveRecord::Base
  belongs_to :category
  belongs_to :user

  attr_accessible :value, :category_id, :description, :user_id, :_value

  DATE_FORMAT = "%Y-%m-%d"

  validates :value, presence: true
  validates :category_id, presence: true
  validates :user_id, presence: true

  def date
    self.created_at.strftime(DATE_FORMAT)
  end

  def _value
    @value
  end

  def _value=(val)
    self.value = val.gsub(/[,]/, '.').to_f.round(1)
  end

  # Using a class method is the preferred way to accept arguments for scopes.
  # These methods will still be accessible on the association objects:

  class << self

    # return array of values of given scope, "values" is Hash instance method
    def costs
      all.map { |expense| expense.value }
    end

    # to avoid creating objects in index view
    def line_sets
      dates.uniq.map { |date| LineSet.new(date, self) }
    end

    def paginated(page)
      all.paginate(:page => page, :per_page => PER_PAGE).order('created_at DESC')
    end

    def narrowed(search)
      proper_params(search) ? filter(search).desc : self.desc
    end

    def desc
      order(created_at: :desc)
    end

    def time_filter(_start, _end)
      _start = self.first.created_at if _start.empty?
      _end = self.last.created_at if _end.empty?
      where(created_at: _start.._end.to_date.end_of_day)
    end

    private

    # checking params of search hash
    def proper_params(search)
      search.try(:has_key?, :category_id) && search.try(:has_key?, :start_date) && search.try(:has_key?, :end_date)
    end

    # return array of dates of given scope
    def dates
      self.all.map { |expense| expense.created_at.to_date }
    end

    # filter
    def filter(params)
      expenses = self.time_filter(params[:start_date], params[:end_date])
      !params[:category_id].empty? ? expenses.where(category_id: params[:category_id]) : expenses
    end

  end

end
