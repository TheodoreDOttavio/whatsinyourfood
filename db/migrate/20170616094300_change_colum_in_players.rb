class ChangeColumInPlayers < ActiveRecord::Migration
  def change
    change_column_default :players, :sucesses, "{}"
    change_column_default :players, :failures, "{}"
    change_column_default :players, :scores, "{}"
    change_column_default :players, :bonuses, "{}"
  end
end
