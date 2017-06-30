class Player < ActiveRecord::Base
  scope :clean, -> { select(:id).where("created_at < '#{DateTime.now() - 7.day}' and name = 'no name'").delete_all }
end
