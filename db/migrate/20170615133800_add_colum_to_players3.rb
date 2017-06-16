class AddColumToPlayers3 < ActiveRecord::Migration
  def change
    add_column :players, :subject, :string, default: ""
  end
end
