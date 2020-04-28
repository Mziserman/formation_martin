class AddPaymenyMethodToContribution < ActiveRecord::Migration[6.0]
  def change
    add_column :contributions, :payment_method, :integer
  end
end
