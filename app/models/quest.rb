class Quest < ActiveRecord::Base
  scope :pickfreshone, -> { select(:upc, :name).where(is_searched: false).limit(1) }
end
