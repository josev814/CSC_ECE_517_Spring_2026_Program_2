require 'faker'
require './test/rails_helper'
require './test/features/shared_tasks.rb'

describe "volunteer assignments", type: :feature do
  before do
    visit login_path
    login_form find('form'), user: ADMIN_USER[:user], password: ADMIN_USER[:passwd]
    expect(page).to have_current_path admins_path
  end

  it "no volunteer assignments" do
    expect(page).to have_current_path admins_path
    click_link "Volunteer Assignments"
    expect(page).to have_current_path volunteer_assignments_path
    expect(page).to have_content 'No Volunteer Assignments Found'
  end

  it 'navigate to volunteer assignments page' do
    visit volunteer_assignments_path
    click_link 'New Volunteer Assignment'
    expect(page).to have_current_path new_volunteer_assignment_path
  end

  describe 'create volunteer assignment', type: :feature do
    before do
      visit new_volunteer_assignment_path
      @form_element = find('#new_volunteer_assignment_form')
    end

    it 'no fill' do
      assignment_form @form_element
      expect(page).to have_content 'Volunteer must exist'
    end

    it 'fill in volunteer' do
      assignment_form @form_element, volunteer_id: BASE_VOLUNTEER[:id]
      expect(page).to_not have_content 'Volunteer must exist'
      expect(page).to have_content 'Event must exist'
    end

    it 'fill in event' do
      assignment_form @form_element, event_id: CURL_EVENT[:id]
      expect(page).to_not have_content 'Event must exist'
      expect(page).to have_content 'Volunteer must exist'
    end

    it 'fill in assignment exceeding hours' do
      assignment_form @form_element,
                      volunteer_id: BASE_VOLUNTEER[:id],
                      event_id: CURL_EVENT[:id],
                      status: 'pending',
                      hours_worked: '36',
                      date_logged: Date.today
      expect(page).to_not have_content 'Event must exist'
      expect(page).to_not have_content 'Volunteer must exist'
      expect(page).to have_content 'Hours worked cannot exceed event duration'
    end

    it 'fill in assignment properly' do
      assignment_form @form_element,
                      volunteer_id: BASE_VOLUNTEER[:id],
                      event_id: CURL_EVENT[:id],
                      status: 'pending',
                      hours_worked: '1',
                      date_logged: Date.today
      expect(page).to_not have_content 'Event must exist'
      expect(page).to_not have_content 'Volunteer must exist'
      expect(page).to_not have_content 'Hours worked cannot exceed event duration'
      expect(page).to have_current_path volunteer_assignment_path(1)
    end
  end

  describe 'volunteer assignment list approval', type: :feature do
    before do
      visit new_volunteer_assignment_path
      @form_element = find('#new_volunteer_assignment_form')
      assignment_form @form_element,
                      volunteer_id: BASE_VOLUNTEER[:id],
                      event_id: CURL_EVENT[:id],
                      status: 'pending',
                      hours_worked: '1',
                      date_logged: Date.today
      visit new_volunteer_assignment_path
      assignment_form @form_element,
                      volunteer_id: BASE_VOLUNTEER[:id],
                      event_id: 1,
                      status: 'approved',
                      hours_worked: '1',
                      date_logged: Date.today
    end

    it 'ensure no approval button' do
      visit volunteer_assignments_path
      row = find('tr', text: 'approved')
      within row do
        expect(page).to_not have_button 'Approve'
      end
    end

    it 'approval pending assignment' do
      visit volunteer_assignments_path
      row = find('tr', text: 'pending')
      within row do
        expect(page).to have_button 'Approve'
        click_button 'Approve'
      end
      expect(page).to have_content 'Volunteer assignment was successfully updated.'
    end
  end
end