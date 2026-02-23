require 'faker'
require "./test/rails_helper"
require './test/features/shared_tasks.rb'

describe "new volunteer", :type => :feature do
  before :context do
    @user = generate_user
  end
  describe "volunteer registration process", type: :feature do
    before do
      visit root_path
      click_link 'Register'
      @form_element = find('form')
    end

    it 'nothing filled in' do
      # nothing filled in
      registration_form @form_element
      expect(page).to have_content "Username can't be blank"
    end

    it 'only username filled in' do
      # only username
      registration_form @form_element, user: @user[:username]
      expect(page).to_not have_content "Username can't be blank"
      expect(page).to have_content "Full name can't be blank"
    end

    it 'username and name filled in' do
      # only username and name
      registration_form @form_element, name: @user[:full_name]
      expect(page).to_not have_content "Full name can't be blank"
      expect(page).to have_content "Email can't be blank"
    end
    it 'empty password' do
      # username, name and email
      registration_form @form_element, email: @user[:email]
      expect(page).to_not have_content "Email can't be blank"
      expect(page).to have_content "Password can't be blank"
    end
    it 'password too short' do
      # username, name, email and short password
      registration_form @form_element, pwd: 'a', pwd2: 'a'
      expect(page).to_not have_content "Password can't be blank"
      expect(page).to have_content "Password is too short"
    end
    it 'passwords do not match (nil confirmation)' do
      # username, name, email and mismatch password
      registration_form @form_element, pwd: @user[:password]
      expect(page).to_not have_content "Password is too short"
      expect(page).to have_content "Password confirmation doesn't match Password"
    end
    it 'passwords do not match' do
      # username, name, email and mismatch password
      registration_form @form_element, pwd: @user[:password], pwd2: ('a' * 10)
      expect(page).to have_content "Password confirmation doesn't match Password"
    end
    it 'username already exists' do
      # valid form fill, but user exists
      registration_form @form_element, user: BASE_VOLUNTEER[:user],
                        pwd: @user[:password],
                        pwd2: @user[:password]
      expect(page).to_not have_content "Password confirmation doesn't match Password"
      expect(page).to have_content 'Username has already been taken'
    end
    it 'invalid email' do
      # Can't use meme@gmail as an invalid email since meme@localhost would classify as a good internal email
      # https://html.spec.whatwg.org/multipage/input.html#valid-e-mail-address
      # username, name and bad email
      registration_form @form_element, user: @user[:username],
                        name: @user[:full_name],
                        email: 'meme@@gmail',
                        pwd: @user[:password],
                        pwd2: @user[:password]
      expect(page).to_not have_content "Email can't be blank"
      expect(page).to have_content "Email is invalid"
    end

    it 'email already exists' do
      # valid form fill, but email exists
      registration_form @form_element, user: @user[:username],
                        email: BASE_VOLUNTEER[:email],
                        pwd: @user[:password],
                        pwd2: @user[:password]
      expect(page).to_not have_content 'Username has already been taken'
      expect(page).to have_content 'Email has already been taken'
    end
    it 'valid registration' do
      @current_user = register_new_user user: @user
      expect(page).to_not have_content 'email exists'
      expect(page).to_not have_content 'errors prohibited this volunteer from being saved'
      expect(page).to have_current_path volunteer_path(@current_user[:id])
      expect(page).to have_content @user[:full_name]
    end
  end

  describe 'with new volunteer' do
    before :context do
      @new_phone = Faker::PhoneNumber.phone_number
      @current_user = register_new_user user:@user
    end

    describe 'update account', :type => :feature do
      before do
        visit login_path
        # visit profile is already logged in, but other tasks require login, not sure why
        unless page.has_content? @current_user[:full_name]
          form = find('form', wait: 5)
          login_form form, user: @current_user[:username], password: @current_user[:password]
          visit root_path
          expect(page).to have_content @current_user[:full_name]
        end
      end

      it 'visit profile' do
        expect(page).to have_content @current_user[:full_name]
        within('nav') do
          click_link @current_user[:full_name]
          click_link "Profile"
        end
        expect(page).to have_current_path volunteer_path(@current_user[:id])
      end

      it 'edit phone' do
        visit volunteer_path(@current_user[:id])
        click_link 'Edit'
        expect(page).to have_current_path edit_volunteer_path(@current_user[:id])
        within('form') do
          fill_in 'volunteer_phone_number', with: @new_phone
          click_button 'Update Volunteer'
        end
        expect(page).to have_current_path volunteer_path(@current_user[:id])
        expect(page).to_not have_content @current_user[:phone_number]
        expect(page).to have_content @new_phone
      end
    end

    describe 'deleted account', :type => :feature do
      before do
        Volunteer.find(@current_user[:id]).destroy
      end
      it 'try login of deleted account' do
        visit login_path
        form_element = find('form')
        login_form form_element, user: @current_user[:username], password: @current_user[:password]
        expect(page).to have_current_path login_path
        expect(page).to have_content 'Invalid Credentials'
      end
    end
  end
end

describe "volunteer login process", type: :feature do

  it "volunteer sign  in" do
    visit login_path
    form_element = find('form')

    login_form form_element
    expect(page).to have_content 'Invalid Credentials'

    login_form form_element, user: BASE_VOLUNTEER[:user]
    expect(page).to have_content 'Invalid Credentials'

    login_form form_element, password: Faker::Internet.password(special_characters: true)
    expect(page).to have_content 'Invalid Credentials'
    within(form_element) do
      username_field = find_field('session_username')
      expect(username_field.value).to eq(BASE_VOLUNTEER[:user])
    end

    login_form form_element, password: BASE_VOLUNTEER[:passwd]

    expect(page).to have_current_path root_path
    expect(page).to have_content BASE_VOLUNTEER[:name]
  end
end

describe "volunteer access restrictions", type: :feature do
  before do
    visit login_path
    form_element = find('form')
    login_form form_element, user: BASE_VOLUNTEER[:user], password: BASE_VOLUNTEER[:passwd]
  end
  
  it "deny admin access" do
    visit admins_path
    expect(page).to have_content 'You do not have access to that page'
    expect(page).to have_current_path root_path
    expect(page).to have_content BASE_VOLUNTEER[:name]
  end

  it "deny volunteer_assignments access" do
    visit volunteer_assignments_path
    expect(page).to have_content 'You do not have access to that page'
    expect(page).to have_current_path root_path
    expect(page).to have_content BASE_VOLUNTEER[:name]
  end

  it "deny access to other volunteer profile" do
    visit volunteer_path(BASE_VOLUNTEER[:id].to_i - 1)
    expect(page).to have_current_path root_path
    expect(page).to have_content 'You are not authorized to access that.'
  end
end

describe "volunteer event actions", type: :feature do
  before do
    visit login_path
    form_element = find('form')
    login_form form_element, user: BASE_VOLUNTEER[:user], password: BASE_VOLUNTEER[:passwd]
  end

  it "list events" do
    click_link 'Events'
    expect(page).to have_content CURL_EVENT[:name]
    expect(page).to have_current_path events_path
  end

  it "view event" do
    click_link 'Events'
    within('#event_4') do
      expect(page).to have_content CURL_EVENT[:name]
      expect(page).to have_text(/\d{4}-\d{2}-\d{2}/)
      click_link 'View'
    end
    expect(page).to have_current_path event_path(4)
    expect(page).to have_content "Volunteers Needed: #{CURL_EVENT[:needed]}"
    expect(page).to have_button "Volunteer"
  end

  it "volunteer and unvolunteer event" do
    visit event_path(4)
    click_button 'Unvolunteer'
    expect(page).to have_content 'You are not signed up for this event.'

    click_button 'Volunteer'
    expect(page).to have_content 'You have signed up for this event (pending approval).'

    click_button 'Volunteer'
    expect(page).to have_content 'You have already volunteered for this event.'

    click_link 'My Events'
    expect(page).to have_current_path my_events_path
    expect(page).to have_content 'View Event'
    click_link 'View Event'
    expect(page).to have_content CURL_EVENT[:name]
    expect(page).to have_content 'Unvolunteer'
    click_button 'Unvolunteer'
    expect(page).to have_content 'You have been removed from this event.'
  end
end

# Keep this as the last step to logout
# Add other steps above this
describe "volunteer logout process", type: :feature do
  before do
    visit login_path
    form_element = find('form')
    login_form form_element, user: BASE_VOLUNTEER[:user], password: BASE_VOLUNTEER[:passwd]
  end

  it "volunteer sign out" do
    click_link BASE_VOLUNTEER[:name]
    click_link 'Sign out'
    expect(page).to have_current_path root_path
    expect(page).to_not have_content BASE_VOLUNTEER[:name]

    visit volunteer_path(11)
    expect(page).to have_content 'You are not authorized to access that.'
    expect(page).to have_current_path root_path
  end
end