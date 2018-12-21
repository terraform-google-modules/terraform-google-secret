# frozen_string_literal: true

require 'rubygems'
require 'json'
# this is the prescribed way to create variables in test from terraform test outputs
foo_id = attribute('foo_id')
contents = attribute('contents')

# this main control block is referenced in the .kitchen.yml file. All tests fall within it.
control "get-gcs-object" do
  describe 'Static outputs' do
    # Not quite sure what this one is testing to be honest...
    it 'have become local variables' do
      expect(foo_id).to match /bar/
    end
    it 'contains the right content' do
      expect(contents).to match "hello world"
    end
  end
end
