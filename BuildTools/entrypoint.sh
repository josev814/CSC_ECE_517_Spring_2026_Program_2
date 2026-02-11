#!/usr/bin/env bash

set -euo pipefail

cd /opt/project || exit

# always using a fresh Gemfile.lock
if [ -f "Gemfile.lock" ] && [ -f /var/local/Gemfile.lock ] && [ $( diff Gemfile.lock /var/local/Gemfile.lock | wc -l) -gt 0 ]; then
  mv Gemfile.lock Gemfile.lock.bk.$(date +"%Y%m%d.%H%M%S")
fi

if [ -f /var/local/Gemfile.lock ]; then
  sudo mv /var/local/Gemfile.lock ./Gemfile.lock
fi

sudo chown ruby:ruby ./Gemfile.lock

# find Gemlock files older than 3 days and delete
while read -r entry; do
  echo "Cleaning up ${entry}"
done < <(find ./ -type f -name "Gemfile.lock.*" -mtime +2)

sudo chown root:ruby /usr/local/bundle/ruby/3.4.0/
sudo chmod 774 /usr/local/bundle/ruby/3.4.0

echo "Running Bundle check"
bundle check
result=$?
echo "Bundle check result: $result"
if [ $result -ne 0 ]; then
  bundle lock --add-platform x86_64-linux
  echo "Running bundle install"
  bundle install
fi

while read -r entry; do
  echo "Owning $entry"
  sudo chown ruby:ruby "${entry}"
done < <(find ./storage/ -name "*.sqlite3")

if [[ "${RAILS_ENV}" == 'production' ]]
then
  bundle exec rails assets:precompile
fi
# as of rails 6 prepare replaces migrate
bundle exec rails db:prepare
bundle exec rails db:seed

exec "$@"
