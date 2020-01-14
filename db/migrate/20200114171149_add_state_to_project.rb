class AddStateToProject < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :aasm_state, :string
  end
end
