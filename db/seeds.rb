# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

def sqlite_primarykey_reset!(table_name)
  # for sqlite reset to sequence to 1
  query_string = "DELETE FROM sqlite_sequence WHERE name='#{table_name}';"
  puts query_string
  ActiveRecord::Base.lease_connection.execute(
    query_string
  )
end

#Destroying data first to have a fresh instance
Admin.destroy_all
# destroy_all doesn't reset the pk
sqlite_primarykey_reset!(Admin.table_name)

Faker::Config.locale = 'en-US'
Faker::Config.random = Random.new(20260206)

puts "Generating admin...."

fake_admin = Faker::Internet.user('username', 'password')
fake_admin.merge!({
  name: Faker::Name.name,
  email: "#{fake_admin[:username]}@ncsu.edu",
})

puts "password=#{fake_admin[:password]}"

Admin.new(
  name: fake_admin[:name],
  email: fake_admin[:email],
  username: fake_admin[:username],
  password: fake_admin[:password]
).save
# Admin.create!(admin)