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

shared_secret = attribute('shared_secret')
app_secret = attribute('app_secret')
project_id = attribute('project_id')

# module inputs
application_name = "app1"
env = "qa"
secret_name = "secret1"
source_file = "examples/manage-secrets/secrets/secret1.txt"

#expected_values
expected_bucket = "#{project_id}-#{application_name}-#{env}-secrets"
expected_file_name = "#{secret_name}.txt"


control "app-secret" do
  title "GCP bucket file content"

  describe command("gsutil cat -h gs://#{expected_bucket}/#{expected_file_name}") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should include "gs://#{expected_bucket}/#{expected_file_name}" }

    let(:data) do
      if subject.exit_status == 0
        subject.stdout
      else
        ''
      end
    end

    describe 'content' do
      it 'should be eq the module output' do
        expect(data).to eq app_secret
      end
      it 'should be the same with source file content' do
        expect(data).to eq File.read(source_file)
      end
    end

  end
end


