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
  needed: 2,
  id: 4
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

# Helper method to fill in the event form with default values, allowing overrides for specific fields
def fill_event_form(title: "Food Drive", description: "Help distribute food.",
                    location: "Community Center",
                    event_date: Date.today + 7,
                    start_time: "09:00",
                    end_time: "11:00",
                    required_volunteers: 3)
  fill_in "Title", with: title
  fill_in "Description", with: description
  fill_in "Location", with: location
  fill_in "Event date", with: event_date
  fill_in "Start time", with: start_time
  fill_in "End time", with: end_time
  fill_in "Required volunteers", with: required_volunteers
end

# Fills in the assignment form
# @note the fields hash maps the function params automatically,
#   this allows us to iterate the fields to enter if they're filled in more easily
def assignment_form(form, volunteer_id: nil, event_id: nil, status: nil, hours_worked: nil, date_logged: nil)
  prefix = 'volunteer_assignment_'
  fields = { volunteer_id:, event_id:, status:, hours_worked:, date_logged: }
  within(form) do
    fields.each do |field, value |
      case field
      when :volunteer_id, :event_id, :status
        # for select fields we find the value of the option and select it
        if value.nil?.eql?(false)
          find("##{prefix}#{field} option[value='#{value}']").select_option
        end
      else
        fill_in "#{prefix}#{field}", with: value if value
      end
    end
    click_button 'Add'
  end
end
