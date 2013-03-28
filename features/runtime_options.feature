Feature: Providing runtime options for blueprints

  Background:
    Given Automux is setup

  Scenario: Providing commands and disabling windows at runtime
    Given I provide the following blueprint
      """
      name: test
      root: '-r:'
      windows:
        - name: top
          opt: '-t'
          panes: top
      """
    When Automux processes this blueprint with the following options
      | option | value |
      | -r     | test  |
    Then the rendered sequence of shell commands should be
      """
      cd test

      tmux start-server
      tmux -u2 new-session -d -s test

      tmux -u2 attach-session -t test
      """

  Scenario: Completing partial commands at runtime
    Given I provide the following blueprint
      """
      name: test
      windows:
        - name: git
          panes: git pull "-r:" master
      """
    When Automux processes this blueprint with the following options
      | option | value  |
      | -r     | origin |
    Then the rendered sequence of shell commands should be
      """
      cd .

      tmux start-server
      tmux -u2 new-session -d -s test

      tmux new-window -t test:0 2> /dev/null
      tmux rename-window -t test:0 git
      tmux send-keys -t test:0 "git pull origin master" C-m

      tmux -u2 attach-session -t test
      """

  Scenario: Providing combined runtime options
    Given I provide the following blueprint
      """
      name: test
      root: '-r:'
      windows:
        - name: vim
          opt: "-v"
          panes: vim
        - name: top
          opt: '-t'
          panes: top
      """
    When Automux processes this blueprint with the following options
      | option | value    |
      | -vtr     | projects |
    Then the rendered sequence of shell commands should be
      """
      cd projects

      tmux start-server
      tmux -u2 new-session -d -s test

      tmux new-window -t test:0 2> /dev/null
      tmux rename-window -t test:0 vim
      tmux send-keys -t test:0 "vim" C-m

      tmux new-window -t test:1 2> /dev/null
      tmux rename-window -t test:1 top
      tmux send-keys -t test:1 "top" C-m

      tmux -u2 attach-session -t test
      """

