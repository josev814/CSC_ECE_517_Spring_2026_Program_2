# Docker Configuration

## Install Docker Desktop
You can use the install_docker.ps1 powershell script to install docker
If doing so ensure you are using an **administrative prompt**
- Click on your Start Windows Icon
- Search for Powershell
- Right-Click on Powershell and select `Run as Administrator`
- Then cd to the directory this repository lives in

```
& BuildTools\windows\install_docker.ps1
```

When installing docker desktop, it will enable the WSL feature, since we run docker on wsl

**Notes:**
- If WSL wasn't previously enabled you will need to restart and run the installer a second time to ensure
WSL is installed and available for Docker
- Your computer must also support Virtualization which is a BIOS setting, if it's not enabled, you man need to enable it
  within your BIOS settings

## Rubymine
**_Docker Desktop must be installed first_**

### Settings
Open Settings `(CTRL + ALT + s)`

Expand the `Build, Execution, Deployment` Section

Under this area you will see Docker

Click The `+` icon to add a Docker Instance to connect to

Ensure that `Docker for Windows` is set to "default" and click `Apply`

Next we'll add our ruby interpreter from docker, still in settings
- Expand `Languages & Frameworks`
- Select `Ruby Interpreters`
- Click the + Icon and select `Remote Interpreter or Version Manager...`
  - Select Docker Compose
  - To the right of the Input box for `Configuration files:`, click the folder icon
    - Navigate to the project repository and then BuildTools.
    - Select the docker-compose.yml file and click ok
  - For the Service Select Ruby
  - Click OK
- Right-Click on the remote just created and rename it as Ruby-2.4-DockerCompose
- Along the row of tools beside the `+` you clicked earlier, you'll see a folder with a yellow asterisk, click on that
  - Add the following path mapping
  - Remote Path to be /opt/project
  - Local Path will point to your repository directory path
  - Click OK

Now we're done with the Settings area

## Running Tests
Open a Terminal Window `Alt+F12`

When opening the Terminal Window within Ruby, it will automatically be in the root of the project

To run the unit tests we run the run_rspec_tests.ps1 script
```powershell
.\BuildTools\windows\run_rspec_tests.ps1
```
This will start up the compose project if it's not currently running and then wait for gems to be installed

Once gems are installed the tests are ran.

### Viewing results
The console outputs show lines covered, if there's a failure and runtime

To view more information, you can look in the coverage directory.

#### Browser view

The index.html file can be viewed in a browser, by
- right-clicking it
- open in
- browser
- select your browser or the RubyMine built-in preview

#### Rubymine Coverage loading
- Click the RubyMine menu
- Click View
- Tool Windows
- Coverage

The coverage are is not open to the side

Click on "Import a report collected in CI from disk"

Navigate to the coverage directory and then load in .resultset.json

This allows you to view any failures or code that hasn't been tested within RubyMine

## Tear down the docker project
```powershell
.\BuildTools\windows\stop_compose_project.ps1
```
