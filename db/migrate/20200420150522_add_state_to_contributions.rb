class AddStateToContributions < ActiveRecord::Migration[6.0]
  def change
    add_column :contributions, :state, :integer, index: true, default: 0
  end
end
