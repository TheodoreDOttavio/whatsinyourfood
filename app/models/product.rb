class Product < ActiveRecord::Base
  validates :item_id, uniqueness: true
  #validates :nf_serving_weight_grams, presence: true

  scope :allbrands, ->(myfield) { select(:brand_name).where("#{myfield} >= 1").distinct.pluck(:brand_name) }
  scope :brandcount, ->(brand) { where(brand_name: brand).count }

  scope :tester, ->(brand, offsets, myfield) { select("#{myfield} as test_condition, *").where(brand_name: brand).where("#{myfield} >= 1").offset(offsets).limit(1) }
end
