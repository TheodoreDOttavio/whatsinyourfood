class Topic < ActiveRecord::Base
  scope :random, -> { offset(rand(Topic.count)).limit(1) }
  #TODO select sum :success and :failure by grouped :name field
  scope :forstats, -> { order(:name, :test_field, :statement) }
end
