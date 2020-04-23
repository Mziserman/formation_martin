class RemoveThumbnailFromRewards < ActiveRecord::Migration[6.0]
  def change
    remove_column :rewards, :thumbnail
  end
end
