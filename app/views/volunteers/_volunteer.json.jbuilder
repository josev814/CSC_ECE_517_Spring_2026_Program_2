json.extract! volunteer, :id, :username, :full_name, :email, :phone_number, :address, :skills_interests, :password_digest, :created_at, :updated_at
json.url volunteer_url(volunteer, format: :json)
