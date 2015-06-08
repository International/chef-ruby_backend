default['ruby_backend']['environment'] = 'production'
default['ruby_backend']['ruby_version'] = '2.2.2'
default['ruby_backend']['envinronment_variables'] = { 
                                                      'RAILS_ENV' => node['ruby_backend']['environment'],
                                                      'RACK_ENV' => node['ruby_backend']['environment']
                                                    }

# Default thin configuration
default['ruby_backend']['configure_thin']                         = false
default['ruby_backend']['thin_settings']['pid']                   = 'tmp/pids/thin.pid'
default['ruby_backend']['thin_settings']['timeout']               = 30
default['ruby_backend']['thin_settings']['wait']                  = 30
default['ruby_backend']['thin_settings']['log']                   = 'log/thin.log'
default['ruby_backend']['thin_settings']['max_conns']             = 1024
default['ruby_backend']['thin_settings']['max_persistent_conns']  = 512
default['ruby_backend']['thin_settings']['servers']               = node['cpu'] && node['cpu']['total'] ? node['cpu']['total'] : 1
default['ruby_backend']['thin_settings']['daemonize']             = true
default['ruby_backend']['thin_settings']['port']                  = 3000
default['ruby_backend']['thin_settings']['address']               = '0.0.0.0'
default['ruby_backend']['thin_settings']['onebyone']              = true

# Set User install for the deploy user
node.set['rbenv']['user_installs'] = [
                                      { 'user' => node['ruby_backend']['deploy_user'] }
                                    ]

node.set['rbenv']['create_profiled'] = false

# Set the PermitUserEnvironment option in sshd config
node.set['openssh']['server']['permit_user_environment'] = 'yes'

# Run updates
node.set['apt']['compile_time_update'] = true

# Setup unattended updates on this server
node.set['apt']['unattended_upgrades']['enable'] = true
node.set['apt']['unattended_upgrades']['allowed_origins'] = ["${distro_id} ${distro_codename}-security",
                                                         "${distro_id} ${distro_codename}-updates"]