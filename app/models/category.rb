class Category < ActiveRecord::Base
  has_many :expenses

  attr_accessible :name

  validates :name, presence: true

end
