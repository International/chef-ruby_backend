name 'ruby_backend'
maintainer 'Lester Celestial'
maintainer_email 'lesterc@sourcepad.com'
license 'Apache 2.0'
description 'Installs ruby with rbenv and configures the server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md')) 
version '0.3.1'

recipe 'ruby_backend', "Installs ruby with rbenv and configures the server for ruby applications deployment"

depends 'apt'
depends 'user'
depends 'openssh'
depends 'ruby_build'
depends 'rbenv'

supports 'ubuntu'

attribute 'ruby_backend/deploy_user',
  display_name: "Deploy User",
  description: "The deploy user who will own the application and where rbenv and ruby would be installed to.",
  required: "required"

attribute 'ruby_backend/application_name',
  display_name: "Application Name",
  description: "Name of the application to be deployed.",
  required: "recommended"

attribute 'ruby_backend/ruby_version',
  display_name: "Ruby version",
  description: "Version of the ruby to be installed",
  default: "2.2.2"

attribute 'ruby_backend/envinronment_variables',
  display_name: "",
  description: "Hash of environment variables to be set on the deploy user",
  default: { 'RAILS_ENV' => 'production', 'RACK_ENV' => 'production' }

attribute 'ruby_backend/deploy_ssh_keys',
  display_name: "SSH Keys",
  description: "SSH keys to be added to the deploy user's ~/.ssh/authorized_keys",
  required: "recommended"

attribute 'ruby_backend/db_settings',
  display_name: "Database setings",
  description: "Hash which contains the database.yml configuration",
  required: "recommended"