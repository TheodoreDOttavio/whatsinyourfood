class Topic < ActiveRecord::Base
  scope :random, -> { offset(rand(Topic.count)).limit(1) }
  scope :randomsubject, ->(subjectname) { where(name: subjectname).offset(rand(Topic.subjectcount(subjectname))).limit(1) }
  scope :subjectcount, ->(subjectname) { where(name: subjectname).count }

  #TODO select sum :success and :failure by grouped :name field
  scope :forstats, -> { order(:name, :test_field, :statement) }

  scope :subjectnames, -> { select(:name).distinct }
end
