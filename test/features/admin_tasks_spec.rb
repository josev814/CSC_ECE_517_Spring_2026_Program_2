require 'faker'
require './test/rails_helper'
require './test/features/shared_tasks.rb'

describe "create new admin", :type => :feature do
  it "try to access new admin" do
    visit new_admin_path
    expect(page).to have_current_url  root_path
    expect(page).to have_content "You do not have access to that page"
  end

  it "try to access new admin logged in" do
    visit login_path
    form_element = find('form')
    login_form form_element, user: ADMIN_USER[:user], password: ADMIN_USER[:passwd]
    expect(page).to have_current_path admins_path
    visit new_admin_path
    expect(page).to have_current_url  admins_path
    expect(page).to have_content "Access Denied"
  end
end

describe "admin login process", type: :feature do
  # before :each do
  # end

  it "admin sign  in" do
    visit login_path
    form_element = find('form')

    # empty form test
    login_form form_element
    expect(page).to have_content 'Invalid Credentials'

    # blank password test
    login_form form_element, user: ADMIN_USER[:user]
    expect(page).to have_content 'Invalid Credentials'

    # bad password test
    login_form form_element, password: Faker::Internet.password(special_characters: true)
    expect(page).to have_content 'Invalid Credentials'
    expect(form_element).to have_field('session_username'), with: ADMIN_USER[:user]

    # username is already filled in at this point
    login_form form_element, password: ADMIN_USER[:passwd]

    expect(page).to have_current_path admins_path
    expect(page).to have_content ADMIN_USER[:name]
  end

  # Keep this as the last step to logout
  describe "admin logout process", type: :feature do
    before do
      visit login_path
      form_element = find('form')
      login_form form_element, user: ADMIN_USER[:user], password: ADMIN_USER[:passwd]
    end

    it "admin sign out" do
      click_link ADMIN_USER[:name]
      click_link 'Sign out'
      expect(page).to have_current_path root_path
      expect(page).to_not have_content ADMIN_USER[:name]

      visit volunteers_path
      expect(page).to have_content 'You do not have access to that page'
      expect(page).to have_current_path root_path
    end
  end
end

describe "volunteer actions", type: :feature do
  before do
    visit login_path
    # form_element = find('form')
    login_form find('form'), user: ADMIN_USER[:user], password: ADMIN_USER[:passwd]
  end

  it "list_volunteers" do
    click_link "Volunteers"
    expect(page).to have_current_path volunteers_path
    expect(page).to have_content BASE_VOLUNTEER[:name]
  end

  it 'view user' do
    visit volunteers_path
    expect(page).to have_current_path volunteers_path
    within("#volunteer_#{BASE_VOLUNTEER[:id]}") do
      click_link 'View Profile'
    end
    expect(page).to have_current_path volunteer_path(BASE_VOLUNTEER[:id])
  end

  it 'access edit user' do
    visit volunteer_path(BASE_VOLUNTEER[:id])
    click_link 'Edit'
    expect(page).to have_current_path edit_volunteer_path(BASE_VOLUNTEER[:id])
  end

  it 'update volunteer phone number' do
    phone_number = Faker::PhoneNumber.phone_number
    visit edit_volunteer_path(BASE_VOLUNTEER[:id])
    within('form') do
      fill_in 'volunteer_phone_number', with: phone_number
      click_button 'Update Volunteer'
    end
    expect(page).to have_content 'Volunteer was successfully updated.'
    expect(page).to have_current_path volunteer_path(BASE_VOLUNTEER[:id])
  end
end