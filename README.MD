# CSC/ECE 517 (OO Design and Development)
## Program 2: Ruby on Rails

### Volunteer Management System

The Volunteer Management System is a web-based application designed to help organizations manage volunteers for events or initiatives. The system allows volunteers to register, sign up for events, be assigned to events, and track volunteering hours. The emphasis of the system is on core functionality rather than user interface design.

---

### Deadlines

- \[Fri 02/23\] Submission
- \[Mon 02/26\] First feedback
- \[Thu 02/28\] Resubmission
- \[Sat 03/03\] Final review

**Note:**
As soon as you start working on the project
- You must create a repo on [github](https://github.com)
- **add the course staff** and teammates as collaborators
- Make sure to make your repository private to prevent potential plagiarism
- Use the GitHub features you learned in Program 0 Github Introduction assignment, like Issues, Branches, Pull Requests, Project Board, etc.

## Volunteer Management System

The Volunteer Management System is a web-based application designed to help organizations manage volunteers for 
events or initiatives. The system allows volunteers to register, sign up for events, be assigned to events, and 
track volunteering hours. The emphasis of the system is on **core functionality rather than user interface design**.

The main components of the system are:

1. Volunteer
2. Organization Admin
3. Event
4. Volunteer Assignment

---

### Volunteer

Volunteer should have the following attributes **(required fields are indicated by an asterisk "\*"):**

- ID \*
- Username \*
- Password \*
- Full Name \*
- Email \*
- Phone Number
- Address
- Skills / Interests
- Total Hours (calculated field)

Volunteers should be able to:

- Sign up for a new account
- Log in with a username and password
- Edit their own profile (except ID and username)
- Delete their own account
- View all available events
- Sign up for events that are open
- View events they are assigned to
- View their volunteering history and total hours

---

### Organization Admin

Admins represent the organization managing volunteers. Admins should have the following attributes **(required fields are indicated by an asterisk "\*"):**

- ID \*
- Username \*
- Password \*
- Name \*
- Email \*

Admins should be able to:

- Log in with a username and password
- Edit their own profile (except ID, username, and password)
- Create, view, edit, and delete volunteers
- Create, view, edit, and delete events
- Assign volunteers to events
- Approve or reject volunteer sign-ups
- View volunteer participation across events

Note: There will be **only one admin**, preconfigured in the system. The admin account cannot be deleted.

---

### Event

Events represent “volunteering opportunities.” Events should have the following attributes **(required fields are indicated by an asterisk "\*"):**

- ID \*
- Title \*
- Description \*
- Location \*
- Event Date \*
- Start Time \*
- End Time \*
- Required Number of Volunteers \*
- Status \* (e.g., open, full, completed)

---

### Volunteer Assignment

Volunteer assignments represent a volunteer’s participation in a specific event. Assignment should have the following attributes  **(required fields are indicated by an asterisk (“\*”)**:

- Assignment ID \*
- Volunteer ID \*
- Event ID \*
- Status \* (e.g., pending, approved, completed, cancelled)
- Hours Worked
- Date Logged

---

### General Requirements

#### Volunteer

- There should be a link on the **volunteer’s home page** to let the volunteer:
  - Edit his/her profile.
  - View all available events with event title, date, location, required number of volunteers, and current number of assigned volunteers.
  - View events he/she is assigned to.
  - View his/her volunteering history and total hours worked.
- Volunteers should be able to sign up for an event only if the event has available volunteer slots.
- Volunteers should not be able to sign up for events that are full or completed.
- Volunteers should be able to withdraw from events they have signed up for.
- Only volunteers who are assigned to a completed event can have hours logged for that event.
- No volunteer should be able to access another volunteer’s profile.
- Make sure volunteers cannot access restricted resources simply by modifying the URL (e.g., trying to view or edit another volunteer’s profile or assignments).

#### Admin

- There should be a link on the **admin’s home page** to let the admin:
  - Edit his/her profile.
  - View all volunteers registered in the system.
  - View all events with event details and current volunteer count.
  - View volunteer assignments across all events, including hours worked.
- When a volunteer signs up for an event, a volunteer assignment is created with pending status, which must be approved by the admin.
  - It means until the assignment is approved by the admin, others are still able to sign up for the same opportunity.
- There will be only one admin in the system, and the admin account is preconfigured. The admin account cannot be deleted.
- The admin is responsible for logging all volunteer hours. The admin will log hours only for volunteers that (s)he knows have participated in that event.

#### Event

- An event should automatically be marked as full when the required number of volunteers is reached, and marked as open when slots become available again.
- When a volunteer withdraws from an event or is removed, the slot they occupied should be released and made available to other volunteers.

#### Volunteer Assignment

- The current number of assigned volunteers for an event should be updated on each assignment or removal of a volunteer.
- If an event is deleted, all volunteer assignments associated with that event should be deleted as well.
- If a volunteer is deleted, all volunteer assignments associated with that volunteer should be deleted as well.
- Volunteer assignment status transitions are controlled by the admin. An assignment can only be marked as *completed* after the associated event is marked as *completed*.

#### Other

- The following validations should be performed:
  - Event start time must be before end time.
  - The required number of volunteers must be greater than 0\.
  - Hours worked must be non-negative and cannot exceed the event duration.
  - Email address must be valid.
- Ensure that required fields are not empty before saving data to the database.
- In the README file, document how to access key functionalities in the application. Example instructions include:
  - By clicking what button on what page a volunteer can sign up for an event
  - By clicking what button on what page a volunteer can withdraw from an event
  - By clicking what button on what page an admin can create a new event
  - By clicking what button on what page an admin can log volunteer hours

---

### Extra Credit:

- Enhance the system to provide analytics and insights into volunteer participation across events. This feature should help admins understand volunteer engagement, workload distribution, and event participation trends. 
- The system should allow the admin to view the following analytics:
  - **Volunteer Activity Summary**
    - Total number of events each volunteer has participated in. 
    - Total hours worked by each volunteer. 
    - Average hours per event per volunteer.
- **Event Participation Summary**
  - Number of volunteers assigned to each event. 
  - Total volunteer hours logged for each event. 
  - Average hours worked per volunteer for each event.
- **Top Volunteers**
  - List the top N volunteers based on:
    - Total hours worked, or
    - Number of events participated in.

- **Low Participation Detection**
  - Identify volunteers who:
    - Have not participated in any events.


- **Constraints & Rules**
  - Analytics must be computed dynamically from existing data (not stored as static values).
  - Only **completed volunteer assignments** should be included in analytics.
  - Volunteers **must not** be able to view analytics **for other volunteers.**
  - Admins must be able to filter analytics by:
    - Date range
    - Event
    - Volunteer (optional)

## **Frequently Asked Questions (FAQs)**

- How to start this project?
  - Scaffolding is a great way to create the initial structure of this project. It automatically creates many files and basic CRUD operations for you. You can go through [this link](https://www.rubyguides.com/2020/03/rails-scaffolding/) to get more information on it. There are several such resources available online.

- Can we generate more classes, if required?
  - The documentation guides through the basic entities and functionalities that are required. You are free to add more classes as per your design … but, make sure your design stays clean; don’t add classes unnecessarily.

- Can we use any 3rd-party gems?
  - Yes, you can. However, gems like Solidus should be avoided because this gem can generate an app for you, and that is not allowed for the project.

- Can you use an LLM to help you write code?
  - Yes, **provided that you turn in the LLM dialog that wrote the code for you**.  You are encouraged to experiment with different designs by asking the LLM to code them, and then figure out which is clearest or most efficient, and submit it, explaining how you have made your choice.

- If the admin account is predefined, how does the admin know how to log in?  Do we just give the admin a predefined login and password?
  - Yes, you seed the database with this information and add it to the README file.

- Would a bare minimum UI consist of a page of links and simple HTML?
  - As long as the functionalities work, it is ok.

- Is the admin able to edit the existing information for students?
  - Yes.

- Is the extra credit included in 90 points for the program, or can we score more than 90?
  - You can score more than 90 if you finish all extra credit tasks.

## Miscellaneous

### Ruby Version

There is no requirement for a Ruby version.
Anything **2.6.X and above** should work perfectly.
However, we suggest using the current version to avoid version conflicts with gems you include.

### Repository

- Please make sure your repository is **private** and is in the ***github.com/ncstate-community***.
- And add all the TAs as collaborators so your work can be graded.

### Testing

- Thoroughly test **one** model and **one** controller ([RSpec](http://rspec.info) testing framework;
  see Week 5 online videos).

### **Deployment**

**Please ensure that your deployment is always accessible for grading.**

You can deploy your app to any of the following:

- PaaS (OpenShift, etc.) with free plans.
    - Heroku does not work anymore.
- Amazon AWS
- [NCSU VCL](https://docs.google.com/document/d/168AveJMHh3trO2vWB9mQ0zGpI2VCZl3iB0g0a7pmjS0/edit?usp=sharing)

Please deploy your application a couple of days before the deadline.  This will give you a chance to work through any issues that arise.  Be sure it is active for two weeks after the deadline so that grading can be completed.

**Please check if your website is UP and running at least once daily to avoid loss of points due to accidental mishaps.**  
**While reviewing others’ work, if you find that any website is down, please email them. You can find the UnityID of a team member, from their *github.com/ncstate-community* username.**

## **Submission**

Your submission in Expertiza should consist of the following:

- A link to your deployed application
- A link to your repository (Keep the repository private for Round 1, this is just for our records)
- The [dialog of your conversation](https://docs.google.com/document/d/1a3fcoZ6_rhPUF8v3vtZK37yckVOM02OcoOYHwbhk67Y/edit?usp=sharing) 
  with an LLM that helped you write the code.
- A README.md file containing:
    - Credentials for the preconfigured admin and any other information that reviewers would find useful
    - **How to test various features (e.g., how to access certain pages, what details to enter in the form, etc.).**

## **Rubrics**

Here is the peer review rubric your peers will use to review your work.

### **Round 1 Rubric**

| Class and Database Design |
| :---- |
| All necessary attributes are present for the volunteer. |
| All necessary attributes are present for the admin. |
| All necessary attributes are present for the event. |
| All necessary attributes are present for the volunteer assignment. |
| **Functionality** |
| A volunteer can sign up for a new account. |
| A volunteer/admin can log in with a username and password. |
| A volunteer can edit and delete their own profile. |
| A volunteer/admin can view all available events with current volunteer capacity. |
| An admin can create, view, edit, and delete events/volunteers/volunteer assignments. |
| A volunteer can sign up for an event if slots are available. |
| A volunteer cannot sign up for an event if it is full or completed. |
| A volunteer can withdraw from an event they signed up for. |
| An admin can assign volunteers to events and approve sign-ups. |
| An admin can mark an event as completed. |
| An admin can log volunteer hours for volunteers who participated in a completed event. |
| A volunteer can view their own volunteer hour history and total hours. |
| A volunteer can access only resources they are allowed to, and cannot access others by simply changing the URL. |
| The code performs all appropriate validations (e.g., non-negative hours, valid email, required fields not empty). |
| An admin can edit their own profile but cannot delete the admin account. |
| An admin can view all volunteers registered in the system. |
| An admin can view all events with details and current volunteer count. |
| An admin can view volunteer assignments across all events, including hours worked. |
| When a volunteer account is deleted, all associated assignments are deleted. |
| When an event is deleted, all associated assignments are deleted. |
| Volunteer slots are accurately updated after sign-ups, withdrawals, or deletions. |
| **Workflow** |
| The workflow is intuitive. Would you suggest making any changes? |
| Overall, do you find other problem(s)? How would you suggest fixing it/them? |
| **Extra credit** |
| This project correctly implements to provide analytics and insights |

### **Round 2 Rubric**

| Software Engineering and Testing |
| :---- |
| The code is written in a clean and readable way. |
| Each method performs only one task. (One method should only handle one task, if there are multiple tasks, there should be function calls. Mention any relevant details.) |
| Variable and method names are indicative of what the variables are storing/handling.(Mention any relevant details.) |
| Commit messages are indicative of what changes were made in the commit. (Mention any relevant details.) |
| This system works as it is supposed to. (If you found any problems in the first round, did the authors fix them? Comment on any functionality that is still failing.) |
| This team made commits in round 2\. |
| The README file contains all the information needed, and the code is well documented, with adequate comments to explain the coding. |
| The testing has been done properly for at least one model. |
| The testing has been done properly for at least one controller. |

| Design and Workflow |
| :---- |
| Overall, do you find other problem(s)? How would you suggest fixing it/them? |
| **LLM Conversation** |
| The team added the LLM conversation transcript in their submission files. |

