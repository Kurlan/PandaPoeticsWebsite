class AddPlayedWordsToBoard < ActiveRecord::Migration
  def self.up
    add_column :boards, :played_words, :text
  end

  def self.down
    remove_column :boards, :played_words
  end
end
