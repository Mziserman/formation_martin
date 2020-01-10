class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :small_blurb
      t.text :long_blurb
      t.float :amount_wanted
      t.integer :thumbnail_id, index: true, null: true
      t.integer :landscape_id, index: true, null: true

      t.timestamps null: false
    end
    create_table :images do |t|
      t.text :image_date

      t.timestamps null: false
    end
  end
end
