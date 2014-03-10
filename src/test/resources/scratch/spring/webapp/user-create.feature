Feature: User - Create

  Background:
    Given there is a new user
    And the user has an "email" of "test_one@email.test"
    And the user has a "firstName" of "Test"
    And the user has a "lastName" of "User"

  Scenario: I create a new user and the user is persisted correctly.
    When I create the user
    Then I should receive a status code of 201
    And the response body should contain the new user
    And the new user should be persisted

  Scenario: I create the same user twice and the second creation fails.
    Given I create the user
    When I create the user again
    Then I should receive a status code of 400

  Scenario: I create a user with an existing email and the creation fails.
    Given I create the user
    When there is another new user
    And the user has an "email" of "test_one@email.test"
    And the user has a "firstName" of "Test2"
    And the user has a "lastName" of "User2"
    And I create the user
    Then I should receive a status code of 400

  Scenario Outline: I create a user with existing name values and the user is persisted correctly.
    Given I create the user
    When there is another new user
    And the user has an "email" of "test_two@email.test"
    And the user has a "firstName" of "<first-name>"
    And the user has a "lastName" of "<last-name>"
    And I create the user
    Then I should receive a status code of 201
    And the response body should contain the new user
    And the new user should be persisted
  Examples:
    | first-name | last-name |
    | Test       | User2     |
    | Test2      | User      |
    | Test       | User      |

  Scenario Outline: I create a user with missing values and the creation fails.
    Given there is a new user
    And the user has an "email" of "<email>"
    And the user has a "firstName" of "<first-name>"
    And the user has a "lastName" of "<last-name>"
    When I create the user
    Then I should receive a status code of 400
  Examples:
    | email               | first-name | last-name |
    |                     | Test       | User      |
    | test_one@email.test |            | User      |
    | test_one@email.test | Test       |           |

  Scenario Outline: I create a user with null values and the creation fails.
    Given there is a new user
    And the user has an "email" of "<email>"
    And the user has a "firstName" of "<first-name>"
    And the user has a "lastName" of "<last-name>"
    When I create the user
    Then I should receive a status code of 400
  Examples:
    | email               | first-name | last-name |
    | null                | Test       | User      |
    | test_one@email.test | null       | User      |
    | test_one@email.test | Test       | null      |

  Scenario Outline: I create a user with missing fields and the creation fails.
    Given there is a new user
    And the user has an "<email>" of "test_one@email.test"
    And the user has a "<first-name>" of "Test"
    And the user has a "<last-name>" of "User"
    When I create the user
    Then I should receive a status code of 400
  Examples:
    | email | first-name | last-name |
    |       | firstName  | lastName  |
    | email |            | lastName  |
    | email | firstName  |           |

  Scenario: I create a user with an invalid field and the creation fails.
    Given the user has an "invalid" of "true"
    When I create the user
    Then I should receive a status code of 400

  Scenario: I create an empty user and the creation fails.
    Given there is a new user
    When I create the user
    Then I should receive a status code of 400