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

require "json"

project_id = attribute('project_id')
secret_file = File.open "/workspace/examples/create-multiply-secrtes/secrets.json"
secrets = JSON.load secret_file

control "secrets" do
  title "Check if all secrets are created and have correct values"

  secrets.each do |secret|
    secret_name = secret["secret_name"]
    application_name = secret["application_name"]
    env = secret["env"]
    secret_value = secret["secret_value"]
    shared = secret["shared"]
    if shared
      then
        bucket_name = "shared-#{project_id}-#{env}-secrets"
      else
        bucket_name =  "#{project_id}-#{application_name}-#{env}-secrets"
    end

    describe command("gsutil cat -h gs://#{bucket_name}/#{secret_name}.txt") do
      its(:exit_status) { should eq 0 }
      its(:stderr) { should include "gs://#{bucket_name}/#{secret_name}.txt" }
      let(:data) do
        if subject.exit_status == 0
          subject.stdout
        else
          ''
        end
      end
      describe 'content' do
        it 'should be the same with source file content' do
          expect(data).to eq secret_value
        end
      end
    end
  end
end


