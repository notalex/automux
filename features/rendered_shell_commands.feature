Feature: User entering a blueprint from commandline
As an Automux user
I want to run Automux with a blueprint
In order to run the shell commands matching the given blueprint

  Scenario: A 4 window blueprint with some fixed indexes and subpanes
    Given I provide the following blueprint
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
      tmux split-window
      tmux send-keys -t test:0 "echo hello" C-m

      tmux -u2 attach-session -t test
      """

  Scenario: Windows with clashing index values
    Given I provide the following blueprint
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

  Scenario: Only session name is provided
    Given I provide the following blueprint
      """
      name: window-less
      """
    When Automux processes this blueprint
    Then the rendered sequence of shell commands should be
      """
      cd .

      tmux start-server
      tmux -u2 new-session -d -s window-less

      tmux -u2 attach-session -t window-less
      """

  Scenario: Providing no name for a window
    Given I provide the following blueprint
      """
      name: name-less
      windows:
        - panes: git pull origin master
      """
    When Automux processes this blueprint
    Then the rendered sequence of shell commands should be
      """
      cd .

      tmux start-server
      tmux -u2 new-session -d -s name-less

      tmux new-window -t name-less:0 2> /dev/null
      tmux send-keys -t name-less:0 "git pull origin master" C-m

      tmux -u2 attach-session -t name-less
      """

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
          panes: git pull '-r:' master
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
          opt: '-v'
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

  Scenario: Using hooks
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

      tmux start-server
      tmux -u2 new-session -d -s hooked

      echo Hello
      rvm use automux

      tmux -u2 attach-session -t hooked

      echo 'I will be back'
      """
