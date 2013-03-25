Feature: Using pre and post hooks for session

  Scenario: Using pre and post hooks together
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
      tmux -u2 new-session -d -s hooked

      tmux -u2 attach-session -t hooked

      echo 'I will be back'
      """

  Scenario: Using erb in hooks
    Given I provide the following blueprint
      """
      name: hooked
      hooks:
        pre: "echo <%= name %>"
      """
    When Automux processes this blueprint
    Then the rendered sequence of shell commands should be
      """
      cd .

      echo hooked

      tmux start-server
      tmux -u2 new-session -d -s hooked

      tmux -u2 attach-session -t hooked
      """
