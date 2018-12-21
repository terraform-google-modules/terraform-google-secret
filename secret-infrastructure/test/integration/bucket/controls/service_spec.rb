# frozen_string_literal: true

require 'rubygems'
require 'json'

# this is the prescribed way to create variables in test from terraform test outputs
app_buckets = attribute('app-buckets')
shared_buckets = attribute('shared-buckets')
expected_app_list = attribute('app-list')
expected_env_list = attribute('env-list')
project_name = attribute('project-name')

control "check app buckets" do
  describe 'App buckets' do
    it 'has the right amount of buckets' do
      expect(app_buckets.length).to match 6
    end
    it 'has the right names for the buckets' do
      expected_app_list.each do |app|
        expected_env_list.each do |env|
          expect(app_buckets).to include("#{app}-#{env}-secrets")
        end
      end
    end
  end
end

control "check shared buckets" do
  describe 'Shared buckets' do
    it 'has the right amount of buckets' do
      expect(shared_buckets.length).to match 3
    end
    it 'has the right names for the buckets' do
      expected_env_list.each do |env|
        expect(shared_buckets).to include("shared-#{project_name}-#{env}-secrets")
      end
    end
  end
end

