class CreateContributions < ActiveRecord::Migration[6.0]
  def change
    create_table :rewards do |t|
      t.references :project
      t.text :blurb
      t.string :name
      t.text :thumbnail
      t.integer :threshold
      t.boolean :limited, default: false
      t.integer :stock

      t.timestamps null: false
    end

    create_table :contributions do |t|
      t.references :user
      t.references :project
      t.references :reward, null: true
      t.references :contribution_type
      t.integer :amount

      t.timestamps null: false
    end
  end
end