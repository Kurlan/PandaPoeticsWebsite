class AddBoardSizeToBoards < ActiveRecord::Migration
  def self.up
    add_column :boards, :board_size, :decimal
  end

  def self.down
    remove_column :boards, :board_size
  end
end
