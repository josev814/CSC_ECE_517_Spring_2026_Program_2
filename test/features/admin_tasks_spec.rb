require 'faker'
require './test/rails_helper'
require './test/features/shared_tasks.rb'

describe "create new admin", :type => :feature do
  it "try to access new admin" do
    visit new_admin_path
    expect(page).to have_current_path(root_path)
    expect(page).to have_content "Access Denied"
  end

  it "try to access new admin logged in" do
    visit login_path
    form_element = find('form')
    login_form form_element, user: ADMIN_USER[:user], password: ADMIN_USER[:passwd]
    expect(page).to have_current_path admins_path
    visit new_admin_path
    expect(page).to have_current_path root_path
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
    within(form_element) do
      username_field = find_field('session_username')
      expect(username_field.value).to eq(ADMIN_USER[:user])
    end
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

describe "events (admin coverage)", type: :feature do
  before do
    visit login_path
    login_form find('form'), user: ADMIN_USER[:user], password: ADMIN_USER[:passwd]
    expect(page).to have_current_path admins_path
  end

  it "admin sees New Event button on events index" do
    visit events_path
    expect(page).to have_link("New Event", href: new_event_path)
  end

  it "admin can reach New Event form" do
    visit events_path
    click_link "New Event"
    expect(page).to have_current_path new_event_path
    expect(page).to have_content "New Event"
    expect(page).to have_selector("form")
    # status is only shown for persisted events, so it should not appear on new
    expect(page).to_not have_select("Status")
  end

  it "admin can create an event and view it from the list" do
    visit new_event_path
    within("form") do
      fill_event_form(title: "Clothing Donation", event_date: Date.today + 10)
      click_button "Create Event"
    end

    visit events_path
    expect(page).to have_content("Clothing Donation")

    row = find("tr", text: "Clothing Donation")
    within(row) do
      click_link "View"
    end

    # _event.html.erb content
    expect(page).to have_content("Event Title:")
    expect(page).to have_content("Clothing Donation")
    expect(page).to have_content("Event Date:")
    expect(page).to have_content("Event Time:")
    expect(page).to have_content("Event Location:")
    expect(page).to have_content("Event Status:")
    expect(page).to have_content("Volunteers Needed:")
    expect(page).to have_content("Volunteers Signed Up:")
  end

  it "admin sees validation errors when required volunteers is invalid" do
    visit new_event_path
    within("form") do
      fill_event_form(title: "Invalid Volunteers", required_volunteers: 0)
      click_button "Create Event"
    end

    expect(page).to have_content("prohibited this event from being saved")
    expect(page).to have_content("Required volunteers")
  end

  it "admin sees a delete option for events (admin-only control)" do
    visit new_event_path
    within("form") do
      fill_event_form(title: "Delete Me Event", event_date: Date.today + 11)
      click_button "Create Event"
    end

    visit events_path
    expect(page).to have_content("Delete Me Event")

    row = find("tr", text: "Delete Me Event")
    within(row) do
      expect(page).to have_link("Delete")
      end
  end

  it "admin open/close from event page" do
    event_name = 'Flip Event'
    states = {
      open: {btn: 'Mark Completed', state: 'open'},
      completed: {btn: 'Re-Open', state: 'completed'}
    }

    visit new_event_path

    within("form") do
      fill_event_form(title: event_name, event_date: Date.today + 11)
      click_button "Create Event"
    end

    visit events_path
    expect(page).to have_content event_name

    row = find("tr", text: event_name)
    within(row) do
      expect(page).to have_button states[:open][:btn]
      click_button states[:open][:btn]
    end

    expect(page).to have_current_path events_path
    expect(page).to have_content "The event #{event_name} was successfully updated."
    row = find("tr", text: event_name)
    within(row) do
      expect(page).to have_content states[:completed][:state]
      expect(page).to have_button states[:completed][:btn]
      click_button states[:completed][:btn]
    end

    expect(page).to have_current_path events_path
    expect(page).to have_content "The event #{event_name} was successfully updated."
    row = find("tr", text: event_name)
    within(row) do
      expect(page).to have_content states[:open][:state]
      expect(page).to have_content states[:open][:btn]
    end

  end
end

describe "events access control (non-admin)", type: :feature do
  it "non-admin does not see New Event or Delete on events index" do
    visit events_path
    expect(page).to_not have_link("New Event", href: new_event_path)
    expect(page).to_not have_link("Delete")
  end
end