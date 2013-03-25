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

      tmux start-server
      tmux -u2 new-session -d -s hooked

      echo Hello
      rvm use automux

      tmux -u2 attach-session -t hooked

      echo 'I will be back'
      """
