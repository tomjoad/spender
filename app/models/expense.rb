class Expense < ActiveRecord::Base
  belongs_to :category
  belongs_to :user

  attr_accessible :value, :category_id, :description, :user_id

  validates :value, presence: true
  validates :category_id, presence: true
  validates :user_id, presence: true

  def date
    self.created_at.strftime("%d-%m-%Y")
  end

end
