@ocis-reva-issue-34
Feature: restrict resharing
  As an admin
  I want to be able to forbid the sharing of a received share globally
  As a user
  I want to be able to forbid a user that received a share from me to share it further

  Background:
    Given the setting "shareapi_auto_accept_share" of app "core" has been set to "no"
    And the administrator has set the default folder for received shares to "Shares"
    Given these users have been created with default attributes:
      | username |
      | user1    |
      | user2    |
      | user3    |
    And these groups have been created:
      | groupname |
      | grp1      |
    And user "user1" has been added to group "grp1"
    And user "user2" has been added to group "grp1"

  @smokeTest
  @issue-2447
  Scenario: disable resharing and check if the received resource can be reshared
    Given the setting "shareapi_allow_resharing" of app "core" has been set to "no"
    And user "user2" has shared folder "simple-folder" with user "user1"
    And user "user1" has accepted the share "simple-folder" offered by user "user2"
    And user "user1" has favorited element "/Shares/simple-folder"
    When user "user1" logs in using the webUI
    And the user opens folder "Shares" using the webUI
    Then the user should not be able to share folder "simple-folder" using the webUI
    When the user browses to the shared-with-me page
#    Then the user should not be able to share folder "simple-folder (2)" using the webUI
    And the user shares folder "simple-folder" with user "User Three" as "Editor" using the webUI
    Then the error message with header "Error while sharing." should be displayed on the webUI
    And as "user3" folder "simple-folder" should not exist
    When the user browses to the favorites page
    Then the user should not be able to share folder "Shares/simple-folder" using the webUI

  @smokeTest
  Scenario: disable resharing and check if the received resource from group share can be reshared
    Given the setting "shareapi_allow_resharing" of app "core" has been set to "no"
    And user "user3" has shared file "lorem.txt" with group "grp1"
    And user "user1" has accepted the share "lorem.txt" offered by user "user3"
    And user "user2" has accepted the share "lorem.txt" offered by user "user3"
    When user "user1" logs in using the webUI
    And the user opens folder "Shares" using the webUI
    Then the user should not be able to share file "lorem.txt" using the webUI
    When the user re-logs in as "user2" using the webUI
    And the user opens folder "Shares" using the webUI
    Then the user should not be able to share file "lorem.txt" using the webUI
