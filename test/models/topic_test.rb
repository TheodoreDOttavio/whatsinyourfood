require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  test "Confirm that rake db seed has populated the table" do
    assert_not_equal 0, Topic.count
  end

  test "Pick a random subject and then a question" do
    obj = Topic.random[0]
    assert_not_nil obj
    assert_not_nil Topic.randomquestion(obj.name)
  end

  test "Confirm that .forstats adds question success by grouping" do
    #Add one success to all questions
    myadd = Topic.all
    myadd.each do |r|
      r["sucesses"] = 1
      r.save
    end
    assert_not_equal 1, Topic.forstats[0]["sucesses"]
  end

  test "Check subject count and selection scopes" do
    assert_not_nil Topic.subjectcount
    assert_not_nil Topic.subjectnames.length
  end
end
