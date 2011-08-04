class AddCurrentTurnToGames < ActiveRecord::Migration
  def self.up
    add_column :games, :current_board, :board
  end

  def self.down
    remove_column :games, :current_board
  end
end
