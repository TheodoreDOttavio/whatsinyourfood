require 'test_helper'

class QuestTest < ActiveSupport::TestCase
  test "Confirm that rake db populate has found its website" do
    assert_not_equal 0, Quest.count
  end

  test "unique name and brand to exclude various package sizes" do
    #TODO
  end
end
