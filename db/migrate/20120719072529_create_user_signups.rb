class CreateUserSignups < ActiveRecord::Migration
  def change
    create_table :user_signups do |t|
      t.string :email

      t.timestamps
    end
  end
end
