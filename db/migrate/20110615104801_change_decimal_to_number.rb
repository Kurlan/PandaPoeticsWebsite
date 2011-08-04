class ChangeDecimalToNumber < ActiveRecord::Migration
  def self.up
    change_column :boards, :board_size, :number, :default=>9
  end

  def self.down
  end
end
