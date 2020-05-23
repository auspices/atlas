# frozen_string_literal: true

class Product
  PRODUCTS = {
    gaea: GAEA = 'GAEA'
  }.freeze

  def self.find(key)
    PRODUCTS.fetch(key)
  end
end
