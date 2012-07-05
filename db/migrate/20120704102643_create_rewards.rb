class CreateRewards < ActiveRecord::Migration
  def change
    create_table :rewards do |t|
      t.string :name
      t.string :short_description
      t.text :long_description
      t.integer :project_id

      t.timestamps
    end
  end
end
