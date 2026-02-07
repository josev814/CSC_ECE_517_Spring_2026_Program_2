class CreateAdmins < ActiveRecord::Migration[8.1]
  def change
    create_table :admins do |t|
      t.string :username
      t.string :password
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
