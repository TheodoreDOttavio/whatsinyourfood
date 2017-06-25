require 'test_helper'

class QuestTest < ActiveSupport::TestCase
  test "Confirm that rake db populate has found its website" do
    assert_not_equal 0, Quest.count
  end

  # test "Pick a random subject and then a question" do
  #   obj = Topic.random[0]
  #   assert_not_nil obj
  #   assert_not_nil Topic.randomquestion(obj.name)
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
