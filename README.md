Ruby backend server chef cookbook
=================================

Requirements
------------
### Cookbooks
The following cookbooks are direct dependencies:
- apt
- user
- openssh
- ruby_build
- chef-rbenv

### Platforms
The following platforms are supported and tested under test kitchen:
- Ubuntu 14.04

Other Debian family distributions are assumed to work.

Attributes
----------
- `node['ruby_backend']['ruby_version']` - Sets the ruby version to be installed to the deploy user. Default value is `"2.2.2"`
- `node['ruby_backend']['envinronment_variables']` - Hash of environment variables to be set on the deploy user. Default values are `{ 'RAILS_ENV' => 'production', 'RACK_ENV' => 'production' }`
- `node['ruby_backend']['deploy_ssh_keys']` - A String or an Array of ssh keys to be placed on the deploy user's `~/.ssh/authorized_keys`. Defaults to `nil`

### Required Attributes
- `node['ruby_backend']['deploy_user']` - The name of the deploy user that will be created on the server.
- `node['ruby_backend']['application_name']` - The name of the application that will be deployed to the server. This attribute is used for creating the deploy directory `/var/www/node['ruby_backend']['application_name']`. This also happens to be Capistrano 3's default deploy folder convention.

Recipes 
-------
This cookbook installs the necessary packages for a Ruby (or Rails) server. Ruby is installed via rbenv.

It also integrates nicely with Capistrano's default configuration. This enables you to deploy right away to servers provisioned by this cookbook. Just make sure to include the capistrano integration for rbenv and you are good to go.

### default
Installs the necessary packages for a Ruby or Rails deployment. Rbenv is installed on a deploy user and environment variables are also set. When ssh keys are provided they are also added to the deploy user's `~/.ssh/authorized_keys`

It is assumed that the pg gem would be used so the package `libpq-dev` is also installed. Since the recipe is targeted for rails deployments, the package `nodejs` is also installed.

This recipe also permits user environments in the sshd_config file and sets the ssh environment variables in `~/.ssh/environment`.

License & Authors
-----------------
- Author:: Lester Celestial

```text
Copyright 2015, Lester Celestial

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
