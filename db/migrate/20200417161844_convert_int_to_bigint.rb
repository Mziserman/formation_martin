class ConvertIntToBigint < ActiveRecord::Migration[6.0]
  def change
    change_column :rewards, :threshold, :bigint
    change_column :contributions, :amount, :bigint
    change_column :projects, :amount_wanted, :bigint
  end
end
