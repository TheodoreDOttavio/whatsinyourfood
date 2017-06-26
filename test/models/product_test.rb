require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  test "Confirm that there is data" do
    assert_not_equal 0, Product.count
  end
end
