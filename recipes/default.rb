include_recipe 'apt'
include_recipe 'apt::unattended-upgrades'
include_recipe 'user'
include_recipe 'openssh'
include_recipe 'ruby_build'

dependencies = %w{ git-core curl build-essential libreadline-dev
                   libcurl4-openssl-dev python-software-properties
                   libffi-dev libpq-dev nodejs}

home_dir =  "/home/#{node['ruby_backend']['deploy_user']}"
bashrc_path = "/home/#{node['ruby_backend']['deploy_user']}/.bashrc"
localenv_path = "#{home_dir}/.localenv"

# Install dependencies
dependencies.each do |dep|
  package dep
end

# Create the deploy user and add the deploy keys
user_account node['ruby_backend']['deploy_user'] do
  manage_home true
  shell "/bin/bash"
  home home_dir
  ssh_keys node['ruby_backend']['deploy_ssh_keys'] if node['ruby_backend']['deploy_ssh_keys']
  action :create
end

if node['ruby_backend'].attribute?('application_name')
  deploy_dir = "/var/www/#{node['ruby_backend']['application_name']}"
  config_dir = "#{deploy_dir}/shared/config"

  # Create the directory where capistrano would deploy
  directory deploy_dir do
    owner node['ruby_backend']['deploy_user']
    group node['ruby_backend']['deploy_user']
    recursive true
    action :create
  end

  # Create the database.yml file if db_settings attribute is present
  if node['ruby_backend'].attribute?('db_settings')
    database_config = "#{config_dir}/database.yml"

    directory config_dir do
      owner node['ruby_backend']['deploy_user']
      group node['ruby_backend']['deploy_user']
      recursive true
      action :create
    end

    template database_config do
      owner node['ruby_backend']['deploy_user']
      group node['ruby_backend']['deploy_user']
      source "database.yml.erb"
    end
  end

  # Create the thin.yml file if thin_settings attribute is present
  if node['ruby_backend']['configure_thin']
    thin_config_dir = "#{config_dir}/thin"

    directory thin_config_dir do
      owner node['ruby_backend']['deploy_user']
      group node['ruby_backend']['deploy_user']
      recursive true
      action :create
    end

    thin_config_file = "#{thin_config_dir}/#{node['ruby_backend']['environment']}.yml"
    template thin_config_file do
      source "thin.yml.erb"
      owner node['ruby_backend']['deploy_user']
      group node['ruby_backend']['deploy_user']
    end
  end

end

# Create a file where environment variables for the app are set
template localenv_path do
  source "localenv.erb"
  owner node['ruby_backend']['deploy_user']
  group node['ruby_backend']['deploy_user']
end

# Create a file where environment variables for the ssh environment are set. This is just a copy of the file above
template "#{home_dir}/.ssh/environment" do
  source "localenv.erb"
  owner node['ruby_backend']['deploy_user']
  group node['ruby_backend']['deploy_user']
end

# Tell .bashrc to load the .localenv file
bash "add_environment_variable" do
  user node['ruby_backend']['deploy_user']
  code <<-EOF
     echo $'\n' >> #{bashrc_path}
     echo '# Generated by the chef ruby_backend cookbook' >> #{bashrc_path}
     echo 'source #{localenv_path}' >> #{bashrc_path}
  EOF
  not_if { File.readlines(bashrc_path).grep(/source \/home\/#{node['ruby_backend']['deploy_user']}\/.localenv}/).any? }
end

include_recipe 'rbenv::user'

bash "add_rbenv_path" do
  user node['ruby_backend']['deploy_user']
  code <<-EOF
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> #{bashrc_path}
  EOF
  not_if { File.readlines(bashrc_path).grep(/export PATH="\$HOME\/.rbenv\/bin:\$PATH"/).any? }
end

bash "init_rbenv_on_bash" do
  user node['ruby_backend']['deploy_user']
  code <<-EOF
    echo 'eval "$(rbenv init -)"' >> #{bashrc_path}
  EOF
  not_if { File.readlines(bashrc_path).grep(/eval "\$\(rbenv init -\)"/).any? }
end

rbenv_rehash "Rehashing #{node['ruby_backend']['deploy_user']}'s rbenv" do
  user node['ruby_backend']['deploy_user']
end

rbenv_ruby node['ruby_backend']['ruby_version'] do
  user node['ruby_backend']['deploy_user']
end

rbenv_global node['ruby_backend']['ruby_version'] do
  user node['ruby_backend']['deploy_user']
end

rbenv_gem "bundler" do
  user node['ruby_backend']['deploy_user']
  action  :install
end