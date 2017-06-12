class AddColumToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :name, :string, default: ""
  end
end
