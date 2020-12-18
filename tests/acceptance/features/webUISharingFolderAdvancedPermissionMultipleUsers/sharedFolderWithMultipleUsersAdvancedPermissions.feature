Feature: Sharing folders with multiple internal users using advanced permissions
  As a user
  I want to set advanced permissions on shared folders with other users
  So that I can control the access on those folders by other collaborators

  Background:
    Given the setting "shareapi_auto_accept_share" of app "core" has been set to "no"
    And the administrator has set the default folder for received shares to "Shares"
    And these users have been created with default attributes:
      | username |
      | user1    |
      | user2    |

  @issue-product-203
  Scenario Outline: share a folder with multiple users using role as advanced permissions role and different extra permissions
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
    And as "user0" folder "/Shares/simple-folder" should not exist
    And user "User Four" should not be listed in the collaborators list on the webUI
    And as "user4" folder "/Shares/simple-folder" should not exist
    Examples:
      | role                 | displayed-role       | extra-permissions     | displayed-permissions | actual-permissions          |
      | Advanced permissions | Advanced permissions | delete                | delete                | read, delete                |
      | Advanced permissions | Advanced permissions | update                | update                | read, update                |
      | Advanced permissions | Advanced permissions | delete, update        | delete, update        | read, delete, update        |
      | Advanced permissions | Advanced permissions | update, create        | update, create        | read, update, create        |

  @issue-ocis-717
  #after fixing the issue merge this scenario into the one above
  Scenario Outline: share a folder with multiple users using role as advanced permissions role and different extra permissions
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
    And as "user0" folder "/Shares/simple-folder" should not exist
    And user "User Four" should not be listed in the collaborators list on the webUI
    And as "user4" folder "/Shares/simple-folder" should not exist
    Examples:
      | role                 | displayed-role       | extra-permissions     | displayed-permissions | actual-permissions          |
      | Advanced permissions | Advanced permissions | create                | create                | read, create                |
      | Advanced permissions | Advanced permissions | share, delete         | share, delete         | read, share, delete         |
      | Advanced permissions | Advanced permissions | share, update         | share, update         | read, update, share         |
      | Advanced permissions | Advanced permissions | share, create         | share, create         | read, share, create         |
      | Advanced permissions | Advanced permissions | delete, create        | delete, create        | read, delete, create        |
      | Advanced permissions | Advanced permissions | share, delete, update | share, delete, update | read, share, delete, update |
      | Advanced permissions | Advanced permissions | share, create, delete | share, create, delete | read, share, delete, create |
      | Advanced permissions | Advanced permissions | share, update, create | share, update, create | read, share, update, create |

  @skipOnOC10 @issue-ocis-717
  #after fixing the issue delete this scenario and use the one(s) above by moving the Examples entries that have been fixed
  Scenario Outline: share a folder with multiple users using role as advanced permissions role and different extra permissions
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
    And as "user0" folder "/Shares/simple-folder" should not exist
    And user "User Four" should not be listed in the collaborators list on the webUI
    And as "user4" folder "/Shares/simple-folder" should not exist
    Examples:
      | role                 | displayed-role       | extra-permissions | displayed-permissions | actual-permissions           |
      | Advanced permissions | Advanced permissions | create            | create, update        | read, create, update         |
      | Advanced permissions | Editor               | delete, create    | ,                     | read, delete, create, update |
