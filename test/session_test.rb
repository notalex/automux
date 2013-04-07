require 'support/test_helper'

describe 'Session' do
  it "should assign window indexes" do
    windows_data = [nil, nil, 1, 0].map do |i|
      HashFactory.build(:window, index: i)
    end

    session = setup_session_with_windows(windows_data)
    session.window_indexes.must_equal [2, 3, 1, 0]
  end

  it "should assign overwrite conflicting indexes" do
    windows_data = [nil, nil, 1, 1].map do |i|
      HashFactory.build(:window, index: i)
    end

    session = setup_session_with_windows(windows_data)
    session.window_indexes.must_equal [0, 2, 1, 1]
  end
end
