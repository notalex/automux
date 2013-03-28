Feature: Handling various errors with relevant messages

  Background:
    Given Automux is setup

  Scenario: Trying to use a non existing blueprint
    When I invoke Automux with the blueprint "test_sample"
    Then the rendered sequence of shell commands should contain
      """
      echo No matching blueprint found
      """
