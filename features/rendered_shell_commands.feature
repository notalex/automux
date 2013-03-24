Feature: User entering a blueprint from commandline
As an Automux user
I want to run Automux with a blueprint
In order to run the shell commands matching the given blueprint

  Scenario: A 4 window blueprint with some fixed indexes and subpanes
    Given I provide the following blueprint
      """
      project_name: test
      root: ~/projects
      windows:
        - name: editor
          layout: main-vertical
          panes:
            - ls
            - top
            - pwd
        - name: htop
          panes:
            - htop
        - name: tester
          index: 1
          panes:
            - pwd
        - name: zero
          index: 0
          panes:
            - pwd
      """
    When Automux processes this blueprint
    Then the rendered sequence of shell commands should be
      """
      cd ~/projects

      tmux start-server
      tmux -u2 new-session -d -s test

      tmux new-window -t test:2 2> /dev/null
      tmux rename-window -t test:2 editor

      tmux send-keys -t test:2 "ls" C-m
      tmux split-window
      tmux send-keys -t test:2 "top" C-m
      tmux split-window
      tmux send-keys -t test:2 "pwd" C-m
      tmux select-layout -t test:2 main-vertical

      tmux new-window -t test:3 2> /dev/null
      tmux rename-window -t test:3 htop
      tmux send-keys -t test:3 "htop" C-m

      tmux new-window -t test:1 2> /dev/null
      tmux rename-window -t test:1 tester
      tmux send-keys -t test:1 "pwd" C-m

      tmux new-window -t test:0 2> /dev/null
      tmux rename-window -t test:0 zero
      tmux send-keys -t test:0 "pwd" C-m

      tmux -u2 attach-session -t test
      """

  Scenario: Windows with clashing index values
    Given I provide the following blueprint
      """
      project_name: test
      root: '~'
      windows:
        - name: editor
          panes:
            - vim
          index: 1
        - name: top
          panes:
            - top
          index: 1
      """
    When Automux processes this blueprint
    Then the rendered sequence of shell commands should be
      """
      cd ~

      tmux start-server
      tmux -u2 new-session -d -s test

      tmux new-window -t test:1 2> /dev/null
      tmux rename-window -t test:1 editor
      tmux send-keys -t test:1 "vim" C-m

      tmux new-window -t test:0 2> /dev/null
      tmux rename-window -t test:0 top
      tmux send-keys -t test:0 "top" C-m

      tmux -u2 attach-session -t test
      """
