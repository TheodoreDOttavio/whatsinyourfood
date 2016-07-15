class AddColumToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :password, :string, default: ""
  end
end
