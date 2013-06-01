Feature: Using pre and post hooks for session

  Scenario: Using session hooks
    Given I have the following blueprint named "test_sample"
      """
      name: hooked
      hooks:
        pre:
          - "echo Hello"
          - "rvm use automux"
        post:
          - <%= select_window 'one' %>
      windows:
        - name: one
        - name: two
      """
    When I invoke Automux with the blueprint "test_sample"
    Then the rendered sequence of shell commands should be
      """
      cd .

      echo Hello
      rvm use automux

      tmux start-server
      tmux new-session -d -s hooked

      tmux move-window -t hooked:0
      tmux rename-window -t hooked:0 one
      tmux send-keys -t hooked:0 "" C-m

      tmux new-window -t hooked:1
      tmux rename-window -t hooked:1 two
      tmux send-keys -t hooked:1 "" C-m

      tmux select-window -t hooked:0

      tmux attach-session -t hooked
      """

  Scenario: Using window hooks
    Given I have the following blueprint named "test_sample"
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
    When I invoke Automux with the blueprint "test_sample"
    Then the rendered sequence of shell commands should be
      """
      cd .

      echo hooked

      tmux start-server
      tmux new-session -d -s hooked

      tmux move-window -t hooked:0
      tmux send-keys -t hooked:0 "pwd" C-m

      tmux new-window -t hooked:1
      tmux rename-window -t hooked:1 echoed-window

      tmux send-keys -t hooked:1 "echo echoed-window start" C-m
      tmux send-keys -t hooked:1 "rvm use custom" C-m
      tmux send-keys -t hooked:1 "ls" C-m
      tmux send-keys -t hooked:1 "echo echoed-window complete" C-m

      tmux attach-session -t hooked
      """
