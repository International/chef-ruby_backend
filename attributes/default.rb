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