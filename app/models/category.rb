class Category < ActiveRecord::Base
  has_many :expenses

  attr_accessible :name

  validates :name, presence: true

  # class << self

  #   def analyze(expenses)
  #     hash = Hash.new
  #     self.all.each do |cat|
  #       sum = 0
  #         expenses.where(category_id: cat.id).each do |expense|
  #           sum += expense.value
  #         end
  #       hash["#{cat.name}"] = sum
  #     end
  #     hash
  #   end

  # end

end
