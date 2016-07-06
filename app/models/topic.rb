class Topic < ActiveRecord::Base
  scope :random, -> { offset(rand(Topic.count)).limit(1) }
end