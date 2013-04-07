def setup_session_with_windows(windows_data)
  data = HashFactory.build(:session, windows: windows_data)
  session = Automux::Core::Tmux::Session.new(data)
  session.setup
  session
end
