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

[Homepage](http://localhost:3000)

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
