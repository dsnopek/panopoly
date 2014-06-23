#!/bin/bash

COMMAND=$1
BUILD_TOP=`dirname $TRAVIS_BUILD_DIR`

export PATH="$HOME/.composer/vendor/bin:$PATH"
export DISPLAY=:99.0
export CHROME_SANDBOX=/opt/google/chrome/chrome-sandbox

# system-install
#
# This is meant to setup the server on Travis-CI so that it can run the tests.
#
system_install() {
  # Add the Google Chrome packages.
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
  sudo apt-get update > /dev/null

  # Create a database for our Drupal site.
  mysql -e 'create database drupal;'

  # Install the latest Drush 6.
  composer global require --prefer-source --no-interaction drush/drush:6.*
  drush dl -y drupalorg_drush-7.x-1.x-dev --destination=$HOME/.drush
  drush cc drush

  # Build Behat dependencies
  cd panopoly/tests/behat
  composer install --prefer-source --no-interaction
  cd ../../../../

  # Build Codebase
  mkdir profiles
  mv panopoly profiles/
  mkdir drupal
  mv profiles drupal/

  # Build the current branch.
  cd drupal
  drush make --yes profiles/panopoly/drupal-org-core.make --prepare-install
  drush make --yes profiles/panopoly/drupal-org.make --no-core --contrib-destination=profiles/panopoly
  drush dl panopoly_demo-1.x-dev
  drush dl diff
  mkdir sites/default/private
  mkdir sites/default/private/files
  mkdir sites/default/private/temp
  cd ../

  # Verify that all the .make files will work on Drupal.org.
  drush verify-makefile drupal/profiles/panopoly/drupal-org.make
  find drupal/profiles/panopoly/modules -name \*.make -print0 | xargs -0 -n1 drush verify-makefile

  # Download an old version to test upgrading from.
  if [[ "$UPGRADE" != none ]]; then drush dl panopoly-$UPGRADE; fi

  # Setup files
  sudo chmod -R 777 drupal/sites/all

  # Setup display for Selenium
  sh -e /etc/init.d/xvfb start
  sleep 5

  # Get Chrome and ChromeDriver
  sudo apt-get install google-chrome-stable
  wget http://chromedriver.storage.googleapis.com/2.9/chromedriver_linux64.zip
  unzip -a chromedriver_linux64.zip

  # Insane hack from jsdevel:
  #   https://github.com/jsdevel/travis-debugging/blob/master/shim.bash
  # This allows chrome-sandbox to work in side of OpenVZ, because I can't
  # figure out how to start chrome with --no-sandbox.
  sudo rm -f $CHROME_SANDBOX
  sudo wget https://googledrive.com/host/0B5VlNZ_Rvdw6NTJoZDBSVy1ZdkE -O $CHROME_SANDBOX
  sudo chown root:root $CHROME_SANDBOX; sudo chmod 4755 $CHROME_SANDBOX
  sudo md5sum $CHROME_SANDBOX

  # Get Selenium
  wget http://selenium-release.storage.googleapis.com/2.41/selenium-server-standalone-2.41.0.jar
 
  # Disable sendmail
  echo sendmail_path=`which true` >> ~/.phpenv/versions/$(phpenv version-name)/etc/php.ini
}

before_tests() {
  # Hack to get the correct version of Panopoly Demo (there was no 1.0-rc4 or 1.0-rc5)
  UPGRADE_DEMO_VERSION=`echo $UPGRADE | sed -e s/^7.x-//`
  case $UPGRADE_DEMO_VERSION in 1.0-rc[45]) UPGRADE_DEMO_VERSION=1.0-rc3;; esac

  # Do the site install (either the current revision or old for the upgrade).
  if [[ "$UPGRADE" == none ]]; then cd drupal; else cd panopoly-$UPGRADE; drush dl panopoly_demo-$UPGRADE_DEMO_VERSION; fi
  drush si panopoly --db-url=mysql://root:@127.0.0.1/drupal --account-name=admin --account-pass=admin --site-mail=admin@example.com --site-name="Panopoly" --yes
  drush dis -y dblog
  drush vset -y file_private_path "sites/default/private/files"
  drush vset -y file_temporary_path "sites/default/private/temp"
  cd ../drupal

  # If we're an upgrade test, run the upgrade process.
  if [[ "$UPGRADE" != none ]]; then cp -a ../panopoly-$UPGRADE/sites/default/* sites/default/ && drush updb --yes; drush cc all; fi

  # Run the webserver
  drush runserver --server=builtin 8888 > /dev/null 2>&1 &
  echo $! > /tmp/web-server-pid
  sleep 3

  cd ..

  # Run the selenium server
  java -jar selenium-server-standalone-2.41.0.jar -Dwebdriver.chrome.driver=`pwd`/chromedriver > /dev/null 2>&1 &
  echo $! > /tmp/selenium-server-pid
  sleep 5
}

run_tests() {
  # Make the Travis tests repos agnostic by injecting drupal_root with BEHAT_PARAMS
  export BEHAT_PARAMS="extensions[Drupal\\DrupalExtension\\Extension][drupal][drupal_root]=$BUILD_OWNER/drupal"

  cd drupal/profiles/panopoly/tests/behat

  # If this isn't an upgrade, we test if any features are overridden.
  if [[ "$UPGRADE" == none ]]; then ../../scripts/check-overridden.sh; fi

  # First, run all the tests in Firefox.
  ./bin/behat --config behat.travis.yml

  # Then run some Chrome-only tests.
  ./bin/behat --config behat.travis.yml -p chrome
}

after_tests() {
  WEB_SERVER_PID=`cat /tmp/webserver-server-pid`
  SELENIUM_SERVER_PID=`cat /tmp/selenium-server-pid`

  # Stop the servers we started
  kill $WEB_SERVER_PID
  kill $SELENIUM_SERVER_PID
}

# We want to always start from the same directory:
cd $BUILD_TOP

case $COMMAND in
  system-install)
    system_install
    ;;

  drupal-install)
    drupal_install
    ;;

  before-tests)
    before_tests
    ;;

  run-tests)
    run_tests
    ;;

  after-tests)
    after_tests
    ;;
esac


