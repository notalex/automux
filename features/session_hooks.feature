Feature: Using pre and post hooks for session

  Scenario: Using session hooks
    Given I provide the following blueprint
      """
      name: hooked
      hooks:
        pre:
          - "echo Hello"
          - "rvm use automux"
        post: "echo 'I will be back'"
      """
    When Automux processes this blueprint
    Then the rendered sequence of shell commands should be
      """
      cd .

      echo Hello
      rvm use automux

      tmux start-server
      tmux new-session -d -s hooked

      tmux attach-session -t hooked

      echo 'I will be back'
      """

  Scenario: Using window hooks
    Given I provide the following blueprint
      """
      name: hooked
      hooks:
        pre: "echo <%= name %>"
      windows:
        - panes: pwd
        - name: echoed-window
          hooks:
            pre:
              - echo <%= name %> start
              - rvm use custom
            post: echo <%= name %> complete
          panes:
            - ls
      """
    When Automux processes this blueprint
    Then the rendered sequence of shell commands should be
      """
      cd .

      echo hooked

      tmux start-server
      tmux new-session -d -s hooked

      tmux new-window -t hooked:0 2> /dev/null
      tmux send-keys -t hooked:0 "pwd" C-m

      tmux new-window -t hooked:1 2> /dev/null
      tmux rename-window -t hooked:1 echoed-window

      tmux send-keys -t hooked:1 "echo echoed-window start" C-m
      tmux send-keys -t hooked:1 "rvm use custom" C-m
      tmux send-keys -t hooked:1 "ls" C-m
      tmux send-keys -t hooked:1 "echo echoed-window complete" C-m

      tmux attach-session -t hooked
      """
