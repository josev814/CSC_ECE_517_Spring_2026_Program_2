class CreateVolunteers < ActiveRecord::Migration[8.1]
  def change
    create_table :volunteers do |t|
      t.string :username
      t.string :full_name
      t.string :email
      t.string :phone_number
      t.string :address
      t.text :skills_interests
      t.string :password_digest

      t.timestamps
    end
  end
end
