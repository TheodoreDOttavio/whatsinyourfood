require 'test_helper'

class QuestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# class Quest < ActiveRecord::Base
#   #validates :is_searched, null: false
#   #validates :is_associated, null: false
#
#   scope :availablecount, -> { where(is_searched: false).count }
#
#   scope :pickfreshone, -> { select(:upc, :name).where(is_searched: false).offset(rand(Quest.availablecount)).limit(1) }
# end
