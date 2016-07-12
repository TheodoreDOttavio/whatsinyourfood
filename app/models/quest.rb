class Quest < ActiveRecord::Base
  #validates :is_searched, null: false
  #validates :is_associated, null: false
  
  #scope :pickfreshone, -> { select(:upc, :name).where(is_searched: false).limit(1) }
  scope :pickfreshone, -> { select(:upc, :name).offset(rand(850)).limit(1) }
end
