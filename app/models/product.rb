class Product < ActiveRecord::Base
  validates :item_id, uniqueness: true

  scope :totalavailable, ->(myfield) { where("#{myfield} > 0").count }
  scope :random, ->(myfield) { select("#{myfield} as test_condition, *").where("#{myfield} > 0").offset(rand(Product.totalavailable(myfield))).limit(1) }
end
