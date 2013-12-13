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

    def dates
      dates = []
      self.all.each do |expense|
        dates << expense.created_at.to_date if !dates.include?(expense.created_at.to_date)
      end
      dates
    end

    def paginated(page)
      paginate(:page => page, :per_page => PER_PAGE).order('created_at DESC')
    end

    def time_filter(start_date, end_date)
      start_date = self.first.created_at if start_date.empty?
      if end_date.empty?
        end_date = self.last.created_at + (60 * 60 * 24)
      else
        end_date = DateTime.strptime(end_date, DATE_FORMAT) + 1
      end
      where("created_at >= :start_date AND created_at <= :end_date",
      start_date: start_date,
      end_date: end_date)
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

  end

end
