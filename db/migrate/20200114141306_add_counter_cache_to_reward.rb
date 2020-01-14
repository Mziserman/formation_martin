class AddCounterCacheToReward < ActiveRecord::Migration[6.0]
  def change
    add_column :rewards, :contributions_count, :integer, default: 0
  end
end
