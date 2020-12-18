@ocis-reva-issue-64
Feature: Sharing files and folders with internal users
  As a user
  I want to share files and folders with other users
  So that those users can access the files and folders

  Background:
    Given the setting "shareapi_auto_accept_share" of app "core" has been set to "no"
    And the administrator has set the default folder for received shares to "Shares"
    And these users have been created with default attributes:
      | username |
      | user1    |
      | user2    |

  @skip @yetToImplement
  Scenario: user tries to share a file from a group which is blacklisted from sharing
    Given group "grp1" has been created
    And user "user1" has been added to group "grp1"
    And user "user3" has been created with default attributes
    And the administrator has browsed to the admin sharing settings page
    When the administrator enables exclude groups from sharing using the webUI
    And the administrator adds group "grp1" to the group sharing blacklist using the webUI
    Then user "user1" should not be able to share file "testimage.jpg" with user "user3" using the sharing API

  @issue-ocis-reva-34
  Scenario: member of a blacklisted from sharing group tries to re-share a file or folder received as a share
    Given these users have been created with default attributes:
      | username |
      | user3    |
    And group "grp1" has been created
    And user "user1" has been added to group "grp1"
    And user "user3" has shared file "testimage.jpg" with user "user1"
    And user "user1" has accepted the share "testimage.jpg" offered by user "user3"
    And user "user3" has shared folder "simple-folder" with user "user1"
    And user "user1" has accepted the share "simple-folder" offered by user "user3"
    And the administrator has enabled exclude groups from sharing
    And the administrator has excluded group "grp1" from sharing
    When user "user1" logs in using the webUI
    And the user opens folder "Shares" using the webUI
    Then the user should not be able to share file "testimage.jpg" using the webUI
    And the user should not be able to share folder "simple-folder" using the webUI

  @issue-ocis-reva-34
  Scenario: member of a blacklisted from sharing group tries to re-share a file inside a folder received as a share
    Given these users have been created with default attributes:
      | username |
      | user3    |
    And group "grp1" has been created
    And user "user1" has been added to group "grp1"
    And user "user3" has created folder "common"
    And user "user3" has moved file "testimage.jpg" to "common/testimage.jpg"
    And user "user3" has shared folder "common" with user "user1"
    And user "user1" has accepted the share "common" offered by user "user3"
    And the administrator has enabled exclude groups from sharing
    And the administrator has excluded group "grp1" from sharing
    And user "user1" has logged in using the webUI
    And the user has opened folder "Shares"
    When the user opens folder "common" using the webUI
    Then the user should not be able to share file "testimage.jpg" using the webUI

  @issue-ocis-reva-34
  Scenario: member of a blacklisted from sharing group tries to re-share a folder inside a folder received as a share
    Given these users have been created with default attributes:
      | username |
      | user3    |
    And group "grp1" has been created
    And user "user1" has been added to group "grp1"
    And user "user3" has created folder "common"
    And user "user3" has created folder "common/inside-common"
    And user "user3" has shared folder "common" with user "user1"
    And user "user1" has accepted the share "common" offered by user "user3"
    And the administrator has enabled exclude groups from sharing
    And the administrator has excluded group "grp1" from sharing
    And user "user1" has logged in using the webUI
    And the user has opened folder "Shares"
    When the user opens folder "common" using the webUI
    Then the user should not be able to share folder "inside-common" using the webUI

  @issue-ocis-reva-34
  Scenario: user tries to share a file or folder from a group which is blacklisted from sharing from files page
    Given group "grp1" has been created
    And user "user1" has been added to group "grp1"
    And the administrator has enabled exclude groups from sharing
    And the administrator has excluded group "grp1" from sharing
    When user "user1" logs in using the webUI
    Then the user should not be able to share file "testimage.jpg" using the webUI
    And the user should not be able to share folder "simple-folder" using the webUI

  @issue-ocis-reva-34
  Scenario: user tries to re-share a file from a group which is blacklisted from sharing using webUI from shared with you page
    Given group "grp1" has been created
    And user "user1" has been added to group "grp1"
    And user "user3" has been created with default attributes
    And user "user2" has shared file "/testimage.jpg" with user "user1"
    And user "user1" has accepted the share "testimage.jpg" offered by user "user2"
    And the administrator has enabled exclude groups from sharing
    And the administrator has excluded group "grp1" from sharing
    And user "user1" has logged in using the webUI
    When the user browses to the shared-with-me page
    And the user opens the share dialog for file "testimage.jpg" using the webUI
    Then the user should not be able to share file "testimage.jpg" using the webUI
