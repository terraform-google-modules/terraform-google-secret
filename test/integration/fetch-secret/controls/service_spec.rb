# frozen_string_literal: true
# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'rubygems'
require 'json'

# this is the prescribed way to create variables in test from terraform test outputs
app_buckets = attribute('app-buckets')
shared_buckets = attribute('shared-buckets')
expected_app_list = attribute('app-list')
expected_env_list = attribute('env-list')
project_name = attribute('project-name')
secret = attribute('mysecret')

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

control "check secret" do
  describe 'Verify secret from gcs' do
    it 'has the correct value' do
      expect(secret).to match "Test object\n"
    end
  end
end

