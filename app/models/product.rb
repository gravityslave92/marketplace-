class Product < ApplicationRecord
  belongs_to :user

  validates_presence_of :title, :user_id, :price
  validates_numericality_of :price, greater_than_or_equal_to: 0
end
