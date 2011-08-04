class CreateRecommendations < ActiveRecord::Migration
  def self.up
    create_table :recommendations do |t|
      t.string :word
      t.references :board
      t.decimal :score
      t.decimal :panda_score
      t.decimal :rank
      t.decimal :word_score
      t.text :spots

      t.timestamps
    end
  end

  def self.down
    drop_table :recommendations
  end
end
