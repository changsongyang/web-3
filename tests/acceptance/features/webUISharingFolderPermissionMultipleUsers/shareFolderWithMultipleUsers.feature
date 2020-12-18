@issue-ocis-717
Feature: Sharing folders with multiple internal users with different permissions
  As a user
  I want to set different permissions on shared folders with other users
  So that I can control the access on those folders by other collaborators

  Background:
    Given the setting "shareapi_auto_accept_share" of app "core" has been set to "no"
    And the administrator has set the default folder for received shares to "Shares"
    And these users have been created with default attributes:
      | username |
      | user1    |
      | user2    |


  Scenario Outline: share a folder with multiple users with different roles and permissions
    Given these users have been created with default attributes:
      | username |
      | user0    |
      | user3    |
      | user4    |
    And user "user1" has logged in using the webUI
    When the user opens the share dialog for folder "simple-folder" using the webUI
    And the user opens the share creation dialog in the webUI
    And the user selects the following collaborators for the share as "<role>" with "<extra-permissions>" permissions:
      | collaborator | type |
      | Regular User | user |
      | User Two     | user |
      | User Three   | user |
      | User Four    | user |
    And the user removes "User Four" as a collaborator from the share
    And the user removes "Regular User" as a collaborator from the share
    And the user shares with the selected collaborators
    And user "user2" accepts the share "simple-folder" offered by user "user1" using the sharing API
    And user "user3" accepts the share "simple-folder" offered by user "user1" using the sharing API
    Then custom permissions "<displayed-permissions>" should be set for user "User Two" for folder "simple-folder" on the webUI
    And custom permissions "<displayed-permissions>" should be set for user "User Three" for folder "simple-folder" on the webUI
    And user "User Two" should be listed as "<displayed-role>" in the collaborators list for folder "simple-folder" on the webUI
    And user "User Three" should be listed as "<displayed-role>" in the collaborators list for folder "simple-folder" on the webUI
    And user "user2" should have received a share with these details:
      | field       | value                 |
      | uid_owner   | user1                 |
      | share_with  | user2                 |
      | file_target | /Shares/simple-folder |
      | item_type   | folder                |
      | permissions | <actual-permissions>  |
    And user "user3" should have received a share with these details:
      | field       | value                 |
      | uid_owner   | user1                 |
      | share_with  | user3                 |
      | file_target | /Shares/simple-folder |
      | item_type   | folder                |
      | permissions | <actual-permissions>  |
    But user "Regular User" should not be listed in the collaborators list on the webUI
    And as "user0" folder "simple-folder (2)" should not exist
    And user "User Four" should not be listed in the collaborators list on the webUI
    And as "user4" folder "simple-folder (2)" should not exist
    Examples:
      | role                 | displayed-role          | extra-permissions             | displayed-permissions  | actual-permissions           |
      | Viewer               | Viewer                  | ,                             | ,                      | read, share                  |
      | Editor               | Editor                  | ,                             | ,                      | all                          |
      | Advanced permissions | Advanced permissions    | ,                             | ,                      | read                         |
      | Advanced permissions | Viewer                  | share                         | ,                      | read, share                  |
      | Advanced permissions | Advanced permissions    | delete, update, create        | delete, update, create | read, delete, update, create |
      | Advanced permissions | Editor                  | share, delete, update, create | ,                      | all                          |

  @skipOnOC10
  #after fixing the issue delete this scenario and use the one above by deleting the @skipOnOCIS tag there
  Scenario Outline: share a folder with multiple users with different roles and permissions
    Given these users have been created with default attributes:
      | username |
      | user0    |
      | user3    |
      | user4    |
    And user "user1" has logged in using the webUI
    When the user opens the share dialog for folder "simple-folder" using the webUI
    And the user opens the share creation dialog in the webUI
    And the user selects the following collaborators for the share as "<role>" with "<extra-permissions>" permissions:
      | collaborator | type |
      | Regular User | user |
      | User Two     | user |
      | User Three   | user |
      | User Four    | user |
    And the user removes "User Four" as a collaborator from the share
    And the user removes "Regular User" as a collaborator from the share
    And the user shares with the selected collaborators
    And user "user2" accepts the share "simple-folder" offered by user "user1" using the sharing API
    And user "user3" accepts the share "simple-folder" offered by user "user1" using the sharing API
    Then custom permissions "<displayed-permissions>" should be set for user "User Two" for folder "simple-folder" on the webUI
    And custom permissions "<displayed-permissions>" should be set for user "User Three" for folder "simple-folder" on the webUI
    And user "User Two" should be listed as "<displayed-role>" in the collaborators list for folder "simple-folder" on the webUI
    And user "User Three" should be listed as "<displayed-role>" in the collaborators list for folder "simple-folder" on the webUI
    And user "user2" should have received a share with these details:
      | field       | value                |
      | uid_owner   | user1                |
      | share_with  | user2                |
      | file_target | /Shares/simple-folder       |
      | item_type   | folder               |
      | permissions | <actual-permissions> |
    And user "user3" should have received a share with these details:
      | field       | value                |
      | uid_owner   | user1                |
      | share_with  | user3                |
      | file_target | /Shares/simple-folder       |
      | item_type   | folder               |
      | permissions | <actual-permissions> |
    But user "Regular User" should not be listed in the collaborators list on the webUI
    And as "user0" folder "simple-folder (2)" should not exist
    And user "User Four" should not be listed in the collaborators list on the webUI
    And as "user4" folder "simple-folder (2)" should not exist
    Examples:
      | role                 | displayed-role          | extra-permissions             | displayed-permissions | actual-permissions           |
      # | Viewer               | Viewer                  | share                         | share                 | read, share                  |
      | Viewer               | Viewer                  | ,                             | ,                     | read                         |
      # | Editor               | Editor                  | share                         | share                 | all                          |
      | Editor               | Editor                  | ,                             | ,                     | read, update, delete, create |
      | Advanced permissions | Viewer                  | ,                             | ,                     | read                         |
      # | Advanced permissions | Viewer                  | share                         | share                 | read, share                  |
      | Advanced permissions | Editor                  | delete, update, create        | ,                     | read, delete, update, create |
      # | Advanced permissions | Editor                  | share, delete, update, create | share                 | all                          |
