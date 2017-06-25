class Topic < ActiveRecord::Base
  scope :random, -> { offset(rand(Topic.count)).limit(1) }
  scope :randomquestion, ->(subjectname = "Fat") { where(name: subjectname).offset(rand(Topic.subjectcount(subjectname))).limit(1) }
  scope :subjectcount, ->(subjectname = "Fat") { where(name: subjectname).count }

  scope :forstats, -> { select("name, SUM(sucesses) as sucesses, SUM(failures) as failures").order(:name).group(:name) }

  scope :subjectnames, -> { select(:name).distinct }
end
