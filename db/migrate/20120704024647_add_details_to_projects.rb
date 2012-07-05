class AddDetailsToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :name, :string
    add_column :projects, :short_description, :string
    add_column :projects, :long_description, :string
    add_column :projects, :video, :string
    add_column :projects, :funding_needed, :float
    add_column :projects, :proposer_name, :string
  end
end
