require 'support/test_helper'

describe 'Session' do
  it "should assign window indexes" do

    windows_data = [nil, nil, 1, 0].map do |i|
      HashFactory.build(:window, index: i)
    end
    data = HashFactory.build(:session, windows: windows_data)

    session = Automux::Core::Tmux::Session.new(data)
    session.setup_windows

    session.window_indexes.must_equal [2, 3, 1, 0]
  end
end
