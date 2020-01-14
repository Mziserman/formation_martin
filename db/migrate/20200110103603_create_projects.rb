class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :small_blurb
      t.text :long_blurb
      t.integer :amount_wanted
      t.integer :thumbnail_id, index: true, null: true
      t.integer :landscape_id, index: true, null: true

      t.timestamps null: false
    end

    create_table :photos do |t|
      t.text :image_data

      t.timestamps null: false
    end

    create_table :project_ownerships do |t|
      t.references :project
      t.references :user
    end
  end
end
