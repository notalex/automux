Feature: Creating, Cloning, Editing and Deleting Blueprints

  Scenario: Editing a blueprint
    Given the user assets folders are setup
      And the user assets has the following blueprint saved as "test_sample"
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
