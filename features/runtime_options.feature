Feature: Providing runtime options for blueprints

  Scenario: Providing commands and disabling windows at runtime
    Given I have the following blueprint named "test_sample"
      """
      name: test
      root: '-r:'
      windows:
        - name: top
          opt: '-t'
          panes: top
      """
    When Automux processes the blueprint "test_sample" with the following options
      | option | value |
      | -r     | test  |
    Then the rendered sequence of shell commands should be
      """
      cd test

      tmux start-server
      tmux new-session -d -s test

      tmux attach-session -t test
      """

  Scenario: Completing partial commands at runtime
    Given I have the following blueprint named "test_sample"
      """
      name: test
      root: '-d:'
      windows:
        - name: git
          panes: git pull "-r:" master
      """
    When Automux processes the blueprint "test_sample" with the following options
      | option | value  |
      | -r     | origin |
    Then the rendered sequence of shell commands should be
      """
      cd .

      tmux start-server
      tmux new-session -d -s test

      tmux move-window -t test:0
      tmux rename-window -t test:0 git
      tmux send-keys -t test:0 "git pull origin master" C-m

      tmux attach-session -t test
      """

  Scenario: Providing combined runtime options
    Given I have the following blueprint named "test_sample"
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
    When Automux processes the blueprint "test_sample" with the following options
      | option | value    |
      | -vtr     | projects |
    Then the rendered sequence of shell commands should be
      """
      cd projects

      tmux start-server
      tmux new-session -d -s test

      tmux move-window -t test:0
      tmux rename-window -t test:0 vim
      tmux send-keys -t test:0 "vim" C-m

      tmux new-window -t test:1
      tmux rename-window -t test:1 top
      tmux send-keys -t test:1 "top" C-m

      tmux attach-session -t test
      """

  Scenario: Passing recipe as the last argument after options
    Given I have the following recipe named "test_recipe"
      """
      cd <%= root %>
      """
      And I have the following blueprint named "test_sample"
        """
        name: test
        root: '-r:'
        windows:
          - panes: vim
        """
    When I invoke Automux with the arguments "test_sample -r projects test_recipe"
    Then the rendered sequence of shell commands should be
      """
      cd projects
      """
