require 'test_helper'

class TopicTest < ActiveSupport::TestCase

  test "is this it" do
    obj = Topic.new
    assert obj.save
  end
end

# class Topic < ActiveRecord::Base
#   scope :random, -> { offset(rand(Topic.count)).limit(1) }
#   scope :randomsubject, ->(subjectname) { where(name: subjectname).offset(rand(Topic.subjectcount(subjectname))).limit(1) }
#   scope :subjectcount, ->(subjectname) { where(name: subjectname).count }
#
#   scope :forstats, -> { select("name, SUM(sucesses) as sucesses, SUM(failures) as failures").order(:name).group(:name) }
#
#   scope :subjectnames, -> { select(:name).distinct }
# end
