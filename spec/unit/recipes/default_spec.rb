require 'spec_helper'

describe 'ruby_backend::default' do
  context 'Ubuntu 14.04' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '14.04') do |node|
        node.set['ruby_backend']['deploy_user'] = 'deploy'
        node.set['ruby_backend']['application_name'] = 'test_app'
      end.converge(described_recipe)
    end

    before do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_call_original
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('ruby_build')
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('rbenv::user')
    end

    it 'includes apt cookbook' do
      expect(chef_run).to include_recipe('apt')
    end

    it 'includes apt::unattended-upgrades cookbook' do
      expect(chef_run).to include_recipe('apt::unattended-upgrades')
    end

    it 'includes user cookbook' do
      expect(chef_run).to include_recipe('user')
    end

    it "includes openssh cookbook" do
      expect(chef_run).to include_recipe('openssh')
    end

    it "includes ruby_build cookbook" do
      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('ruby_build')
      chef_run
    end

    it "includes ruby_build cookbook" do
      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('rbenv::user')
      chef_run
    end

    dependencies = %w{ git-core curl build-essential libreadline-dev
                   libcurl4-openssl-dev python-software-properties
                   libffi-dev libpq-dev nodejs}

    dependencies.each do |dep|
      it "installs #{dep}" do
        expect(chef_run).to install_package(dep)
      end
    end


  end
end
