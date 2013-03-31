Feature: User using a custom recipe

  Scenario: Simple recipe with no tmux related code
    Given I have the following recipe named "test_recipe"
      """
      echo using the <%= name %> blueprint
      """
      And I have the following blueprint named "test_sample"
        """
        name: test
        windows:
          - panes: vim
        """
    When I invoke Automux with the recipe "test_recipe" and the blueprint "default"
    Then the rendered sequence of shell commands should be
      """
      echo using the test blueprint
      """

  Scenario: Using a recipe that skips the hooks and options features
    Given I have the following recipe named "test_recipe"
      """
      cd <%= root %>

      = start_server
      = new_session

      - windows.each do |window|
        = new_window(window)

        - window.panes.each do |pane|
          = create_pane if pane.index > 0
          = send_keys(window, pane.command)
        - end
      - end

      = attach_session
      """
      And I have the following blueprint named "test_sample"
        """
        name: test
        options:
          status: off
        windows:
          - name: vim
            hooks:
              pre: echo Hello
            index: 2
            panes: vim
        """
    When I invoke Automux with the recipe "test_recipe" and the blueprint "test_sample"
    Then the rendered sequence of shell commands should be
      """
      cd .

      tmux start-server
      tmux new-session -d -s test

      tmux new-window -t test:2 2> /dev/null
      tmux send-keys -t test:2 "vim" C-m

      tmux attach-session -t test
      """
