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
contents = attribute('contents')

# this main control block is referenced in the .kitchen.yml file. All tests fall within it.
control "get-gcs-object" do
  describe 'Output validation' do
    it 'contains the right content' do
      expect(contents).to match "hello world"
    end
  end
end
