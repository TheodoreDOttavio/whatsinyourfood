class Product < ActiveRecord::Base
  validates :item_id, uniqueness: true

  scope :totalavailable, ->(myfield, mn, mx) { where("#{myfield} >= #{mn} and #{myfield} <= #{mx}").count }

  #based on range of values between 0-1 of pergram, these scopes find the 30% and 60% values
  scope :pergrammax, ->(myfield) {select("MAX(#{myfield}) as top_value")}

  scope :random, ->(myfield, mn=0.0001, mx=1000, selectedids=1) { select("#{myfield} as test_condition, *").where("#{myfield} >= #{mn} and #{myfield} <= #{mx} and id is not #{selectedids}").offset(rand(Product.totalavailable(myfield, mn, mx))).limit(1) }
end
