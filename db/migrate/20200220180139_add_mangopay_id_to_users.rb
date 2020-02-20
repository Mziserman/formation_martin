class AddMangopayIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :mangopay_id, :string
  end
end
