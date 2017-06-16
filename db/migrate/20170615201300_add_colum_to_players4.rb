class AddColumToPlayers4 < ActiveRecord::Migration
  def change
    add_column :players, :bonuses, :string, default: ""
  end
end
