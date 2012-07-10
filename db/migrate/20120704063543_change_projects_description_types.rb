class ChangeProjectsDescriptionTypes < ActiveRecord::Migration
  def up
    change_column :projects, :short_description, :text, limit: nil
    change_column :projects, :long_description, :text
  end

  def down
    change_column :projects, :short_description, :string
    change_column :projects, :long_description, :string
  end
end
