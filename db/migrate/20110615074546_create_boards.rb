class CreateBoards < ActiveRecord::Migration
  def self.up
    create_table :boards do |t|
      t.text :content
      t.references :game
      t.number :board_size
      t.timestamps
    end
  end

  def self.down
    drop_table :boards
  end
end
