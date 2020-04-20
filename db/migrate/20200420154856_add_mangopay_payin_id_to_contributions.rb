class AddMangopayPayinIdToContributions < ActiveRecord::Migration[6.0]
  def change
    add_column :contributions, :mangopay_payin_id, :string
  end
end
