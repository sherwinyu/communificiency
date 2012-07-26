class AddProposerIdToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :proposer_id, :integer
  end
end
