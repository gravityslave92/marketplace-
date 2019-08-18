class Product < ApplicationRecord
  belongs_to :user

  validates_presence_of :title, :user_id, :price
  validates_numericality_of :price, greater_than_or_equal_to: 0

  scope :filter_by_title, lambda { |keyword|
    where('lower(title) LIKE ?', "%#{keyword.downcase}%")
  }
  scope :above_or_equal_to_price, lambda { |price|
    where('price >= ?', price)
  }
  scope :below_or_equal_to_price, lambda { |price|
    where('price <= ?', price)
  }
  scope :recent, lambda { order(:updated_at) }

  class << self
    def search(params = {})
      products = if params[:product_ids].present?
                   Product.find(params[:product_ids])
                 else
                   Product.all
                 end

      products = products.filter_by_title(params[:keyword]) if params[:keyword]
      products = products.above_or_equal_to_price(params[:min_price]) if params[:min_price]
      products = products.below_or_equal_to_price(params[:max_price]) if params[:max_price]
      products = products.recent if params[:recent]

      products
    end
  end
end
