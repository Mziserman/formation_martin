class AddMangopayWalletIdToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :mangopay_wallet_id, :string
  end
end
