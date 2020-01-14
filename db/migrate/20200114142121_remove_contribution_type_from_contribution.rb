class RemoveContributionTypeFromContribution < ActiveRecord::Migration[6.0]
  def change
    remove_index :contributions, :contribution_type_id
    remove_column :contributions, :contribution_type_id
  end
end
