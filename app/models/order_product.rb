class OrderProduct < ApplicationRecord
  belongs_to :product
  belongs_to :order
  has_one :review

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :product_present
  validate :order_present

  before_save :finalize

  def product_price
      product.cost
  end

  def total_price
    p = product_price * quantity

    if quantity < 5
      p
    elsif quantity >= 5 && quantity < 10
      p * 0.95
    elsif quantity >= 10 && quantity < 20
      p * 0.90
    elsif quantity >= 20
      p * 0.80
    end
  end

  private
    def product_present
      if product.nil?
        errors.add(:product, "is not valid or is not active.")
      end
    end

    def order_present
      if order.nil?
        errors.add(:order, "is not valid order.")
      end
    end

    def finalize
      self[:product_price] = product_price
      self[:total_price] = quantity * self[:product_price]
    end
end
