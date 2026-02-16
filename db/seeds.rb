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

puts "Generating Volunteers"

Volunteer.destroy_all
# destroy_all doesn't reset the pk
sqlite_primarykey_reset!(Volunteer.table_name)
(0..Faker::Number.within(range: 2..10)).to_a.each do |person|
  volunteer = Faker::Internet.user('username', 'password')
  skills = []
  (0..Faker::Number.within(range: 2..4)).to_a.each do |i|
    if i.modulo(2).eql?(0)
      skills.push(Faker::Hobby.activity)
    else
      skills.push(Faker::Job.key_skill)
    end
  end

  skills.uniq!
  puts "Volunteer #{person} Credentials: #{volunteer}"

  volunteer.merge!({
    full_name: Faker::Name.name,
    email: "#{volunteer[:username]}@ncsu.edu",
    phone_number: Faker::PhoneNumber.phone_number,
    address: Faker::Address.full_address,
    skills_interests: skills.to_json
  })
  Volunteer.new(
    volunteer
  ).save
end

puts "Generating Events"

Event.destroy_all
# destroy_all doesn't reset the pk
sqlite_primarykey_reset!(Event.table_name)

(0..Faker::Number.within(range: 2..10)).to_a.each do |_|
  lang = Faker::ProgrammingLanguage.name
  event_date = Faker::Date.forward(days: 90)
  start_time = Faker::Time.between_dates(from: event_date, to: event_date, period: :morning)
  end_time = Faker::Time.between_dates(from: event_date, to: event_date, period: :afternoon)
  event_data = {
    title: "Tutoring for #{lang}",
    description: "Tutor individuals in the #{lang} programming language",
    location: Faker::University.name,
    event_date: event_date,
    start_time: start_time,
    end_time: end_time,
    required_volunteers: Faker::Number.within(range: 2..5)
  }
  puts event_data
  Event.new(event_data).save
end