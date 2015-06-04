require 'serverspec'

# Required by serverspec
set :backend, :exec

describe "Ruby Backend" do
  it "installs ruby deps" do

    ruby_dependencies = %w{ git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev
                        libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev
                        libcurl4-openssl-dev python-software-properties libffi-dev }


    ruby_dependencies.each do |dep|
      expect package(dep).to be_installed
    end

  end

  
end