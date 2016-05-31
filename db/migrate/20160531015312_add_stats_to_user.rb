class AddStatsToUser < ActiveRecord::Migration
  def change
    add_column :users, :score, :integer, :default => 0
    add_column :users, :correct, :integer, :default => 0
    add_column :users, :incorrect, :integer, :default => 0
  end
end
