class AddColumToPlayers2 < ActiveRecord::Migration
  def change
    add_column :players, :scores, :string, default: ""
  end
end
