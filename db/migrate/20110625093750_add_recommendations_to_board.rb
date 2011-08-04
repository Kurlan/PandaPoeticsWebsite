class AddRecommendationsToBoard < ActiveRecord::Migration
  def self.up
    add_column :boards, :recommendations, :text
  end

  def self.down
    remove_column :boards, :recommendations
  end
end
