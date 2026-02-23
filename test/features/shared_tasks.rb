BASE_VOLUNTEER = {
  user: 'leopoldo',
  name: 'Sen. Loren Brown',
  passwd: 'xcCx1nZU5nQgY1r',
  email: 'leopoldo@ncsu.edu',
  id: '11'
}

CURL_EVENT = {
  name: 'Tutoring for Curl',
  date: '2026-05-16',
  start_time: '08:10 AM',
  end_time: '05:15 PM',
  location: 'Macejkovic University',
  needed: 2
}

ADMIN_USER = {
  user: 'gussie',
  name: 'Adelaide Hermann',
  passwd: 'qVusjy8n1GqxID'
}

def generate_user
  new_user = Faker::Internet.user('username', 'password')
  skills = []
  (0..Faker::Number.within(range: 2..4)).to_a.each do |i|
    if i.modulo(2).eql?(0)
      skills.push(Faker::Hobby.activity)
    else
      skills.push(Faker::Job.key_skill)
    end
  end

  skills.uniq!

  new_user.merge!({
    full_name: Faker::Name.name,
    email: "#{new_user[:username]}@ncsu.edu",
    phone_number: Faker::PhoneNumber.phone_number,
    address: Faker::Address.full_address,
    skills_interests: skills.to_json
  })
  new_user
end

def register_new_user(user)
  visit new_volunteer_path
  form_element = find('form')
  user = user[:user]
  registration_form form_element, user: user[:username],
                    name: user[:full_name],
                    email: user[:email],
                    pwd: user[:password],
                    pwd2: user[:password],
                    phone: user[:phone_number],
                    address: user[:address],
                    skills: user[:skills]

  registered_user = Volunteer.find_by(username: user[:username])
  user[:id] = registered_user.id
  return user
end

def login_form(form, user: nil, password: nil)
  within(form) do
    fill_in 'session_username', with: user if user
    fill_in 'session_password', with: password if password
    click_button 'Login'
  end
end

def registration_form(form, user: nil, name: nil, email: nil, phone: nil, address: nil, skills: nil, pwd: nil, pwd2: nil)
  within(form) do
    fill_in 'volunteer_username', with: user if user
    fill_in 'volunteer_full_name', with: name if name
    fill_in 'volunteer_email', with: email if email
    fill_in 'volunteer_phone_number', with: phone if phone
    fill_in 'volunteer_address', with: address if address
    fill_in 'volunteer_skills_interests', with: skills if skills
    fill_in 'volunteer_password', with: pwd if pwd
    fill_in 'volunteer_password_confirmation', with: pwd2 if pwd2
    click_button 'Create Volunteer'
  end
end