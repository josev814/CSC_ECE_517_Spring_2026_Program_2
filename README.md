# Volunteer Management System

## Admin credentials

### Admin is create via Faker using rails db:seed

User: gussie

Password: qVusjy8n1GqxID

## Generated Content

Faker is used to prepopulate data we do this by using `rails db:seed`

The seed used is 20260206 which ensures that we generate the same data every time.

Volunteers:

|username|password|
|--|--|
|zack|LGkF9bxTTXX|
|bart|nnTa9a7zkAC|
|shawnda|fcFh3RXpUw2G|
|vi.douglas|eRje9RPHHiYCV9|
|qiana_padberg|whAp4TkLFWq|
|mirian_powlowski|AY75mrKyjADSj1e|
|kandice|JqThcaL8xPHbMhoB|
|margaretta|bMD4uICfH|
|alva|2TvO1AiYUQaW0Ox|
|justin|va08ocS9e7ZK|
|leopoldo|xcCx1nZU5nQgY1r|

## Access the Website

[Homepage](http://152.7.177.202:8888/)

## Logging in

Once on the homepage, on the right side of the page you can login with any of the credentials above.

If you login with the admin user, you will be directed to that admin dashboard. 
Otherwise, you are redirected back to the homepage on a successful login.

You will notice when logged in the navigation bar will change to show your "full name".
If you click your name a drop down will appear
The links here allow you to logout or view your profile.

---

## Extra Gems Installed

- Faker
  - Used to generate random user data
- rspec-rails
  - Used to run rspec rails tests
- database_cleaner
  - Used to erase the test db before seeding
- simplecov (-json|-html|-console)
  - Used to generate coverage reports

## Rspec Testing
To run Rspec Tests you run the below command from the root directory
```bash
bundle exec rspec ./test/
```
The console will show the coverage all code in the app directory

simplecov-html and simplecov-json store their results in the coverage folder.

### To view the html report
In Rubymine:
- Open the coverage folder
- Right-Click index.html
- Hover over "Open In" -> Browser
- Click on "Built-in Preview"

### To view the JSON report
This report is meant when running tests for CI/CD

- Open the Rubymine menu (sandwhich at the top right)
- Hover Over View -> Tool Windows and click Coverage
- A new window pane will appear on the right
- Click on "Import a report collected in CI from disk"
- Navigate to the project directory
- Go to coverage and select .resultset.json
- Now you can expand the coverage report folders
- As you click on a file it will open the file
  - What's highlighted in red are lines that don't have tests covering them

### Generating tests with Capybara
Under the test directory we have a folder called features.  This is where we keep the Capybara feature tests

You can use the admin_tasks_spec.rb as an example of how to design tests.

If you feel that you keep repeating steps
- Create a function in shared_tasks for the steps.
- Then you can call the function in your tests

When describing a test, your user will not be logged in by default, so you will need to have a user login. 
We perform this step in the admin_tasks_spec and volunteer_tasks_spec.


[Capybara Cheatsheet](https://github.com/jvargas6_ncstate/CSC_ECE_517_Spring_2026_Program_2/blob/main/docs/CAPYBARA.md)


## Assignment Details

[Assignment Information](https://github.com/jvargas6_ncstate/CSC_ECE_517_Spring_2026_Program_2/blob/main/docs/ASSIGNMENT_README.md)


## User Instructions for Volunteers

1. Once the homepage has been reached, volunteers can register an account or login to the system.

2. For registration, prospective volunteers should be prepared to fill in typical fields (username, full name, email, password, etc).

3. After registration/login, users may select the 'Events' Tab to see a list of all available events.

4. The user can then click the 'View' button and be brought to the page to sign-up for the specific event. 

5. The user can select 'Volunteer' and be treated to a banner indicating successful sign-up **if the event currently has space and pending approval of the site admin.** The user has the option of unvolunteering from the event from the same window. 

6. The user can then navigate to "My Events" to track the status of the site admin's approval or cancellation of their assignment to the event. This status will be one of either: pending, approved, completed, or cancelled. These assignments depend on the status of the event and the admin's decisions on user assignment. 


## Admin Responsibilities and Tasks Guide
The Admin holds the following responsibilities and abilities:
- Manage Volunteer accounts
- Manage Events
- Manage Volunteer Assignments

### Logging In
The Admin account is already created. To login, use the credentials defined in [Admin Credentials](#admin-credentials) section.
### Managing Volunteers
The admin can manage volunteer accounts by navigating to the Volunteers page. A link to this page is located on the navbar at the top of the page.
#### Viewing a Volunteer Account
1. Navigate to Volunteers page.
2. Click on "View Profile" link next to volunteer.
#### Creating a Volunteer Account
1. Navigate to Volunteers page.
2. Click on blue "New Volunteer" button.
3. Fill out form for new volunteer account.
4. Click on blue "Create Volunteer" button at the bottom of the form.
#### Editing a Volunteer Account
1. Navigate to Volunteers page.
2. Click on the "View Profile" link next to the desired user.
3. Click on blue "Edit" button.
4. Edit desired information (Username is unavailable for edit).
5. Click on blue "Update Volunteer" button to save volunteer details.
#### Deleting a Volunteer Account
1. Navigate to Volunteers page
2. Click on "Delete User" link next to desired volunteer.
3. Click "OK" when prompted by the "Are you sure?" pop-up confirmation.
#### Viewing Volunteer Assignments from Volunteer Page
1. Navigate to Volunteers page
2. Click on "Assignments" link next to desired volunteer.

The Admin can manage volunteer assignments from this link. Those actions are discussed in the Volunteer Assignments section.

### Managing Events
#### Creating an Event
1. Navigate to Events page
2. Click on blue "New Event" button
3. Select desired details.
4. Click on "Create Event" button.
#### Editing an Event
1. Navigate to Events page
2. Click on "View" link next to the desired Event
3. Click on yellow "Edit" button
4. Modify desired details
5. Click "Update Event" button at the end of the form.
#### Deleting an Event
1. Navigate to Events page
2. Click on "Delete" link next to desired Event.
3. Confirm deletion by selecting "OK" when prompted by the "Are you sure?" popup

### Managing Volunteer Assignments
Volunteer Assignments are used to track the relationship between a volunteer and an event.
#### Creating a Volunteer Assignment
While volunteer assignments are implictly created when a Volunteer signs up for an event, the admin can also create a volunteer assignment, thereby volunteering a user for an event.
1. Navigate to Volunteer Assignments page
2. Click on blue "New Volunteer Assignment" button
3. Select desired volunteer, event, status, hours worked, and date logged.
4. Click on blue "Add" button.
#### Editing a Volunteer Assignment
1. Navigate to Volunteer Assignments page
2. Click on "View" link next to the desired Volunteer
3. Click on blue "Edit" button
4. Modify desired details
5. Click blue "Add" button at the end of the form.
#### Deleting a Volunteer Assignment
1. Navigate to Volunteer Assignments page
2. Click on "Delete" link next to desired Volunteer.
3. Confirm deletion by selecting "OK" when prompted by the "Are you sure?" popup

### Common Admin Workflow
The Admin is responsible for managing the lifecycle of events and volunteer assignments. When an event is created (see [Creating an Event](#creating-an-event)), the status of the event will automatically move from "open" to "full" state once the Required Volunteer quota is met. The amount of Volunteers signed up will only increment once the admin edits a Volunteer Assignment (see [Editing a Volunteer Assignment](#editing-a-volunteer-assignment)) to move from "pending" to "approved" status.

At any point, the Admin can move the state of the event from either "open" or "full" to "completed" by editing the Event (see [Editing an Event](#editing-an-event)).

Once an event is completed, the Admin can move the Volunteer Assignment status from an "Approved" state to a "Completed" state (see [Logging Volunteer Hours (Admin Only)](#logging-volunteer-hours-admin-only) and/or [Editing a Volunteer Assignment](#editing-a-volunteer-assignment)).

See the [Assignment Details](#assignment-details) section for more information on Admin responsibilities and restrictions.

