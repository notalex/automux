require 'support/test_helper'

describe 'command_line' do
  it "must work when invoked without arguments" do
    system('bin/automux').must_equal true
  end
end
