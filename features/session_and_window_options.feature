Feature: Handling session/window specific options

  Scenario: setting options for session and window together
    Given I provide the following blueprint
      """
      name: test
      options:
        status-left: '#S>'
        status: off
      windows:
        - panes: pwd
          hooks:
            post: ls
          options:
            automatic-rename: off
            window-status-bg: black
      """
    When Automux processes this blueprint
    Then the rendered sequence of shell commands should be
      """
      cd .

      tmux start-server
      tmux new-session -d -s test

      tmux set-option status-left '#S>'
      tmux set-option status 'off'

      tmux new-window -t test:0 2> /dev/null
      tmux send-keys -t test:0 "pwd" C-m

      tmux set-window-option -t test:0 automatic-rename 'off'
      tmux set-window-option -t test:0 window-status-bg 'black'

      tmux send-keys -t test:0 "ls" C-m

      tmux attach-session -t test
      """

  Scenario: Setting the base index
    Given I provide the following blueprint
      """
      name: test
      options:
        base-index: 2
      windows:
        - panes: pwd
        - panes: ls
      """
    When Automux processes this blueprint
    Then the rendered sequence of shell commands should be
      """
      cd .

      tmux start-server
      tmux new-session -d -s test

      tmux set-option base-index '2'

      tmux new-window -t test:2 2> /dev/null
      tmux send-keys -t test:2 "pwd" C-m

      tmux new-window -t test:3 2> /dev/null
      tmux send-keys -t test:3 "ls" C-m

      tmux attach-session -t test
      """
