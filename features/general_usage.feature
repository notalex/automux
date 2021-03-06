Feature: User entering a blueprint from commandline
As an Automux user
I want to run Automux with a blueprint
In order to run the shell commands matching the given blueprint

  Scenario: A 4 window blueprint with some fixed indexes and subpanes
    Given I have the following blueprint named "test_sample"
      """
      name: test
      root: ~/projects
      windows:
        - name: editor
          layout: main-vertical
          panes:
            - ls
            - top
            - pwd
        - name: htop
          panes: htop
        - name: tester
          index: 1
          panes:
            - pwd
        - name: zero
          index: 0
          panes: [pwd, echo hello]
      """
    When I invoke Automux with the blueprint "test_sample"
    Then the rendered sequence of shell commands should be
      """
      cd ~/projects

      tmux start-server
      tmux new-session -d -s test

      tmux move-window -t test:2
      tmux rename-window -t test:2 editor

      tmux send-keys -t test:2 "ls" C-m
      tmux split-window
      tmux send-keys -t test:2 "top" C-m
      tmux split-window
      tmux send-keys -t test:2 "pwd" C-m
      tmux select-layout -t test:2 main-vertical

      tmux new-window -t test:3
      tmux rename-window -t test:3 htop
      tmux send-keys -t test:3 "htop" C-m

      tmux new-window -t test:1
      tmux rename-window -t test:1 tester
      tmux send-keys -t test:1 "pwd" C-m

      tmux new-window -t test:0
      tmux rename-window -t test:0 zero
      tmux send-keys -t test:0 "pwd" C-m
      tmux split-window
      tmux send-keys -t test:0 "echo hello" C-m

      tmux attach-session -t test
      """

  Scenario: Windows with clashing indexes will be overwritten
    Given I have the following blueprint named "test_sample"
      """
      name: test
      root: '~'
      windows:
        - name: editor
          panes: vim
          index: 1
        - name: top
          panes: top
          index: 1
      """
    When I invoke Automux with the blueprint "test_sample"
    Then the rendered sequence of shell commands should be
      """
      cd ~

      tmux start-server
      tmux new-session -d -s test

      tmux move-window -t test:1
      tmux rename-window -t test:1 editor
      tmux send-keys -t test:1 "vim" C-m

      tmux new-window -t test:1
      tmux rename-window -t test:1 top
      tmux send-keys -t test:1 "top" C-m

      tmux attach-session -t test
      """

  Scenario: Only session name is provided
    Given I have the following blueprint named "test_sample"
      """
      name: window-less
      """
    When I invoke Automux with the blueprint "test_sample"
    Then the rendered sequence of shell commands should be
      """
      cd .

      tmux start-server
      tmux new-session -d -s window-less

      tmux attach-session -t window-less
      """

  Scenario: Providing no name for a window
    Given I have the following blueprint named "test_sample"
      """
      name: name-less
      windows:
        - panes: git pull origin master
      """
    When I invoke Automux with the blueprint "test_sample"
    Then the rendered sequence of shell commands should be
      """
      cd .

      tmux start-server
      tmux new-session -d -s name-less

      tmux move-window -t name-less:0
      tmux send-keys -t name-less:0 "git pull origin master" C-m

      tmux attach-session -t name-less
      """

  Scenario: Providing flags for tmux
    Given I have the following blueprint named "test_sample"
      """
      name: flagged
      flags: -u2
      windows:
        - panes: vim
      """
    When I invoke Automux with the blueprint "test_sample"
    Then the rendered sequence of shell commands should be
      """
      cd .

      tmux start-server
      tmux -u2 new-session -d -s flagged

      tmux move-window -t flagged:0
      tmux send-keys -t flagged:0 "vim" C-m

      tmux -u2 attach-session -t flagged
      """

  Scenario: Windows with separate roots
    Given I have the following blueprint named "test_sample"
      """
      name: test
      root: '~'
      windows:
        - panes: vim
          root: 'projects'
        - panes: top
      """
    When I invoke Automux with the blueprint "test_sample"
    Then the rendered sequence of shell commands should be
      """
      cd ~

      tmux start-server
      tmux new-session -d -s test

      tmux move-window -t test:0
      tmux send-keys -t test:0 "cd projects" C-m
      tmux send-keys -t test:0 "vim" C-m

      tmux new-window -t test:1
      tmux send-keys -t test:1 "top" C-m

      tmux attach-session -t test
      """
