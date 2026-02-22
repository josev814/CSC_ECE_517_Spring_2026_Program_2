# VCL Setup

## Git

On VCL
generate an ssh key for github

```bash
ssh-keygen -t ed25519 -C "<your_email>"
```

`cat` the location of your .pub key which should be under `/home/<your_user>/.ssh/`

Add that as a deployment key for your git repository

### Clone the repository
On VCL
```bash
sudo apt-get update
sudo apt-get install git -y
eval $(ssh-agent -s)
ssh-add ~/.ssh/<your_ssh_key>
mkdir -p ~/app
cd ~/app
git clone git@github.com:jvargas6_ncstate/CSC_ECE_517_Spring_2026_Program_2.git .
```

## Docker
### Install dependencies
This installs docker and it's dependencies along with vim and htop

```bash
bash BuildTools/vcl/docker_setup.sh
```
>
> Note: When using docker-compose up there's a weird build issue pertaining to the Gemlock.fil
> **Backup the Gemfile.lock **
> `mv Gemfile.lock Gemfile.lock.bk`
> This will get regenerated when docker-compose runs
> 

### Standup the containers
Run the startup_project, but do so from the root of the project

```bash
bash BuildTools/vcl/start_project.sh
```
This will create a .env file if it doesn't exist.

The env file will
- set the environment as "development"
- map port 80 to 3000

It will then launch the compose project

You can verify the compose project is up by running
```bash
sudo docker logs --follow rails_volunteers
```

You'll see this output in the logs
```
Puma starting in single mode...
* Puma version: 7.2.0 ("On The Corner")
* Ruby version: ruby 3.4.8 (2025-12-17 revision 995b59f666) +PRISM [x86_64-linux]
*  Min threads: 3
*  Max threads: 3
*  Environment: $RAILS_ENV
*          PID: 1
* Listening on http://0.0.0.0:3000
```
Since we're running in debug mode you will see other output in the logs like the db queries that are running

### Teardown the containers
This can be helpful is we sync code and it doesn't update.

Just have the project tear down and that run start again to rebuild it.
```bash
bash BuildTools/vcl/stop_project.sh
```
