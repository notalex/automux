Feature: Handling various errors with relevant messages

  Scenario: Trying to use a non existing blueprint
    When I invoke Automux with the blueprint "test_sample"
    Then the rendered sequence of shell commands should contain
      """
      echo Unable to find blueprint named test_sample.yml
      """

  Scenario: Trying to use a non existing recipe
    When I invoke Automux with the recipe "unknown" and the blueprint "default"
    Then the rendered sequence of shell commands should contain
      """
      echo Unable to find recipe named unknown.sh.erb
      """

  Scenario: Trying to edit a non existing blueprint
    When I invoke Automux to "edit" the blueprint "test_sample"
    Then the rendered sequence of shell commands should contain
      """
      echo Unable to find blueprint named test_sample.yml
      """

  Scenario: Trying to edit a non existing blueprint
    When I invoke Automux to "edit" the blueprint "test_sample"
    Then the rendered sequence of shell commands should contain
      """
      echo Unable to find blueprint named test_sample.yml
      """

  Scenario: Trying to remove a non existing blueprint
    When I invoke Automux to "rm" the blueprint "test_sample"
    Then the rendered sequence of shell commands should contain
      """
      echo Unable to find blueprint named test_sample.yml
      """

  Scenario: Trying incorrect blueprint opts
    Given I have the following blueprint named "test_sample"
      """
      name: opt-less
      root: '-r'
      """
    When Automux processes the blueprint "test_sample" with the following options
      | option | value |
      | -n     | test  |
    Then the rendered sequence of shell commands should contain
      """
      echo Incorrect option passed. Try -h to check valid options.
      """
