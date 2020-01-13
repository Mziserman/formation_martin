class PassImagesDataToProjectTable < ActiveRecord::Migration[6.0]
  def change
    drop_table :photos

    add_column :projects, :thumbnail_data, :text
    remove_column :projects, :thumbnail_id

    add_column :projects, :landscape_data, :text
    remove_column :projects, :landscape_id
  end
end
