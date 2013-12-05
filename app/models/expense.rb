class Expense < ActiveRecord::Base
  belongs_to :category
  belongs_to :user

  attr_accessible :value, :category_id, :description, :user_id

  PER_PAGE = 50
  DATE_FORMAT = "%d-%m-%Y"

  validates :value, presence: true
  validates :category_id, presence: true
  validates :user_id, presence: true

  def date
    self.created_at.strftime("%d-%m-%Y")
  end

  # Using a class method is the preferred way to accept arguments for scopes.
  # These methods will still be accessible on the association objects:

  class << self

    def paginated(page)
      paginate(:page => page, :per_page => PER_PAGE).order('created_at DESC')
    end

    def time_filter(start_date, end_date)
      where("created_at >= :start_date AND created_at <= :end_date",
      start_date: start_date,
      end_date: end_date)
    end

  end

end
