@ocis-konnectd-issue-26
Feature: login users
  As a user
  I want to be able to log into my account
  So that I have access to my files

  As an admin
  I want only authorised users to log in
  So that unauthorised access is impossible

  @skip
  Scenario: admin login
    Given the user has browsed to the login page
    When the user clicks the authenticate button
    And the user logs in with username "admin" and password "admin" using the webUI
    And the user authorizes access to web
    Then the files table should be displayed
    And the files table should not be empty

  Scenario: logging out
    Given these users have been created with default attributes:
      | username |
      | user1    |
    And user "user1" has logged in using the webUI
    And the user has browsed to the files page
    When the user logs out of the webUI
    Then the user should be redirected to the IdP login page

  @ocisSmokeTest
  Scenario: logging out redirects to the url with state attribute
    Given these users have been created with default attributes:
      | username |
      | user1    |
    And user "user1" has logged in using the webUI
    And the user has browsed to the files page
    When the user logs out of the webUI
    Then the user should be on page with the url containing "state="
    When user "user1" logs in using the webUI
    Then the files table should be displayed

  Scenario: try to login with invalid username
      Given these users have been created with default attributes:
        | username |
        | user1    |
      And the user has browsed to the login page
      When the user tries to log in with username "invalid" and password "1234" using the webUI
      Then the warning 'Logon failed. Please verify your credentials and try again.' should be displayed on the login page

  @ocis-konnectd-issue-68
  Scenario: try to login with valid username and invalid password
      Given these users have been created with default attributes:
        | username |
        | user1    |
      And the user has browsed to the login page
      When the user tries to log in with username "user1" and password "invalid" using the webUI
      Then the files table should be displayed
#      Then the warning 'Logon failed. Please verify your credentials and try again.' should be displayed on the login page

