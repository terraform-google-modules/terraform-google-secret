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


app_buckets = attribute('app_buckets')
shared_buckets = attribute('shared_buckets')
project_id = attribute('project_id')
apps = ["app1", "app100500"]
envs = ["dev", "qa", "prod"]


control "secrets-infrastrucure" do
  envs.each do |env|
    describe google_storage_bucket(name: "shared-#{project_id}-#{env}-secrets") do
      it { should exist }
      its('storage_class') { should eq 'MULTI_REGIONAL' }
      it 'should be presented in shared_buckets list' do
        expect(shared_buckets).to include("shared-#{project_id}-#{env}-secrets")
      end
    end
  end


  apps.each do |app|
    envs.each do |env|
      describe google_storage_bucket(name: "#{project_id}-#{app}-#{env}-secrets") do
        it { should exist }
        its('storage_class') { should eq 'MULTI_REGIONAL' }
        it 'should be presented in app_buckets list' do
          expect(app_buckets).to include("#{project_id}-#{app}-#{env}-secrets")
        end
      end
    end
  end


  describe 'created buckets' do
    it 'have the right amount of app-buckets' do
      expect(app_buckets.length).to match (apps.length * envs.length)
    end

    it 'have the right amount of shared-buckets' do
      expect(shared_buckets.length).to match envs.length
    end
  end
end
