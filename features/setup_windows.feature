Feature: Creating Window objects from user provided data

  Background:
    Given Automux is setup

    Scenario: Window with conflicting indexes
    Given I have provided a blueprint with the following window information
      | name   | index  | panes   |
      | first  | 1      | top     |
      | second |        | pwd     |
      | third  | 1      | ls      |
      | fourth | 0      | echo    |
    When the windows are setup
    Then the window with the name "first" should have the following
      | index |
      | 1     |
      And the window with the name "second" should have the following
        | index |
        | 2     |
      And the window with the name "third" should have the following
        | index |
        | 3     |
      And the window with the name "fourth" should have the following
        | index |
        | 0     |
