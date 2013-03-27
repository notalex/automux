Feature: Creating, Cloning, Editing and Deleting Blueprints

  Background:
    Given the user assets folders are setup

  Scenario: Editing a blueprint
    Given the user assets has the following blueprint saved as "test_sample"
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
