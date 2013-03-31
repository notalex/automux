Feature: Creating, Cloning, Editing and Deleting Blueprints

  Scenario: Editing a blueprint
    Given I have the following blueprint named "test_sample"
      """
      name: created-using-cuke
      windows:
        - panes: ls
      """
    When I invoke Automux to "edit" the blueprint "test_sample"
    Then the rendered sequence of shell commands should be
      """
      $EDITOR $HOME/.automux/blueprints/test_sample.yml
      """

  Scenario: Creating a new blueprint
    When I invoke Automux to "create" the blueprint "test_sample"
    Then the rendered sequence of shell commands should be
      """
      cp $HOME/.automux/blueprints/default.yml $HOME/.automux/blueprints/test_sample.yml
      $EDITOR $HOME/.automux/blueprints/test_sample.yml
      """

  Scenario: Copying a blueprint
    When I call Automux to "copy" the blueprint "default" as "test_sample"
    Then the rendered sequence of shell commands should be
      """
      cp $HOME/.automux/blueprints/default.yml $HOME/.automux/blueprints/test_sample.yml
      echo default.yml copied
      """

  Scenario: Using an alias to copy blueprint
    When I call Automux to "cp" the blueprint "default" as "test_sample"
    Then the rendered sequence of shell commands should be
      """
      cp $HOME/.automux/blueprints/default.yml $HOME/.automux/blueprints/test_sample.yml
      echo default.yml copied
      """

  Scenario: Deleting a blueprint
    Given I have the following blueprint named "test_sample"
      """
      name: created-using-cuke
      windows:
        - panes: ls
      """
    When I invoke Automux to "delete" the blueprint "test_sample"
    Then the rendered sequence of shell commands should be
      """
      rm $HOME/.automux/blueprints/test_sample.yml
      echo test_sample.yml deleted
      """

  Scenario: Deleting blueprint using the alias
    Given I have the following blueprint named "test_sample"
      """
      name: created-using-cuke
      windows:
        - panes: ls
      """
    When I invoke Automux to "rm" the blueprint "test_sample"
    Then the rendered sequence of shell commands should be
      """
      rm $HOME/.automux/blueprints/test_sample.yml
      echo test_sample.yml deleted
      """
