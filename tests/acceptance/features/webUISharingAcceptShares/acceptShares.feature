Feature: accept/decline shares coming from internal users
  As a user
  I want to have control of which received shares I accept
  So that I can keep my file system clean

  Background:
    Given the setting "shareapi_auto_accept_share" of app "core" has been set to "no"
    And the administrator has set the default folder for received shares to "Shares"
    And these users have been created with default attributes:
      | username |
      | user1    |
      | user2    |
    And user "user2" has logged in using the webUI

@ocis-reva-issue-34
  Scenario: reject a share that you received as user and as group member
    Given these groups have been created:
      | groupname |
      | grp1      |
    And user "user2" has been added to group "grp1"
    And user "user1" has shared folder "/simple-folder" with user "user2"
    And user "user1" has shared folder "/simple-folder" with group "grp1"
    And the user has browsed to the shared-with-me page
    When the user declines share "simple-folder" offered by user "User One" using the webUI
    Then folder "simple-folder" shared by "User One" should be in "Declined" state on the webUI
    When the user browses to the files page
    Then folder "/Shares" should not be listed on the webUI

  @issue-2512 @skip @issue-4102 @ocis-reva-issue-34
  Scenario: reshare a share that you received to a group that you are member of
    Given these groups have been created:
      | groupname |
      | grp1      |
    And user "user2" has been added to group "grp1"
    And user "user1" has shared folder "/simple-folder" with user "user2"
    And user "user2" has accepted the share "simple-folder" offered by user "user1"
    And the user has browsed to the files page
    And the user opens folder "Shares" using the webUI
    When the user shares folder "simple-folder" with group "grp1" as "Viewer" using the webUI
    And the user unshares folder "simple-folder" using the webUI
    And the user browses to the shared-with-me page using the webUI
    Then folder "simple-folder" shared by "User One" should be in "Declined" state on the webUI
    And folder "simple-folder" shared by "User Two" should not be listed in the webUI
    And folder "simple-folder" should not be listed on the webUI

  @smokeTest @skip @issue-4102 @ocis-reva-issue-34
  Scenario: unshare an accepted share on the "All files" page
    Given these groups have been created:
      | groupname |
      | grp1      |
    And user "user2" has been added to group "grp1"
    And user "user1" has shared folder "/simple-folder" with user "user2"
    And user "user1" has shared folder "/testimage.jpg" with group "grp1"
    And user "user2" has accepted the share "simple-folder" offered by user "user1"
    And user "user2" has accepted the share "testimage.jpg" offered by user "user1"
    And the user has browsed to the files page
    When the user opens folder "Shares" using the webUI
    And the user unshares folder "simple-folder" using the webUI
    And the user unshares file "testimage.jpg" using the webUI
    Then folder "simple-folder" should not be listed on the webUI
    And file "testimage.jpg" should not be listed on the webUI
    When the user browses to the shared-with-me page using the webUI
    Then folder "simple-folder" shared by "User One" should be in "Declined" state on the webUI
    And file "testimage.jpg" shared by "User One" should be in "Declined" state on the webUI

  @skip @yetToImplement
  Scenario: User-based accepting checkbox is not visible while global is disabled
    Given the setting "Automatically accept new incoming local user shares" in the section "Sharing" has been disabled
    And user "user1" has logged in using the webUI
    And the user has browsed to the personal sharing settings page
    Then User-based auto accepting checkbox should not be displayed on the personal sharing settings page in the webUI

  Scenario: User receives files when auto accept share is disabled
    Given user "user1" has uploaded file with content "test" to "toshare.txt"
    And user "user1" has shared file "toshare.txt" with user "user2"
    When the user browses to the shared-with-me page using the webUI
    Then file "toshare.txt" shared by "User One" should be in "Pending" state on the webUI
    When the user browses to the files page
    Then file "toshare.txt" should not be listed on the webUI
    And folder "Shares" should not be listed on the webUI

  Scenario: receive shares with same name from different users
    Given user "user3" has been created with default attributes
    And user "user3" has shared file "lorem.txt" with user "user2"
    And user "user1" has shared file "lorem.txt" with user "user2"
    When the user browses to the shared-with-me page using the webUI
    Then file "lorem.txt" shared by "User One" should be in "Pending" state on the webUI
    And file "lorem.txt" shared by "User Three" should be in "Pending" state on the webUI

  Scenario: decline an offered (pending) share
    Given user "user1" has uploaded file with content "test" to "toshare.txt"
    And user "user1" has uploaded file with content "test" to "anotherfile.txt"
    And user "user1" has shared file "toshare.txt" with user "user2"
    And user "user1" has shared file "anotherfile.txt" with user "user2"
    And the user has browsed to the shared-with-me page
    When the user declines share "toshare.txt" offered by user "User One" using the webUI
    Then file "toshare.txt" shared by "User One" should be in "Declined" state on the webUI
    And file "anotherfile.txt" shared by "User One" should be in "Pending" state on the webUI
    When the user browses to the files page
    Then file "toshare.txt" should not be listed on the webUI
    And file "anotherfile.txt" should not be listed on the webUI

  Scenario: accept an offered (pending) share
    Given user "user1" has uploaded file with content "test" to "toshare.txt"
    And user "user1" has uploaded file with content "test" to "anotherfile.txt"
    And user "user1" has shared file "toshare.txt" with user "user2"
    And user "user1" has shared file "anotherfile.txt" with user "user2"
    And the user has browsed to the shared-with-me page
    When the user accepts share "toshare.txt" offered by user "User One" using the webUI
    Then file "toshare.txt" shared by "User One" should be in "Accepted" state on the webUI
    And file "anotherfile.txt" shared by "User One" should be in "Pending" state on the webUI
    And the file "toshare.txt" shared by "User One" should be in "Accepted" state on the webUI after a page reload
    And the file "anotherfile.txt" shared by "User One" should be in "Pending" state on the webUI after a page reload
    When the user browses to the files page
    And the user opens folder "Shares" using the webUI
    Then file "toshare.txt" should be listed on the webUI
    And file "anotherfile.txt" should not be listed on the webUI

  @ocis-product-276
  Scenario: accept a previously declined share
    Given user "user1" has shared file "lorem.txt" with user "user2"
    And user "user1" has shared file "testimage.jpg" with user "user2"
    And user "user2" has declined the share "lorem.txt" offered by user "user1"
    And the user has browsed to the shared-with-me page
    When the user accepts share "lorem.txt" offered by user "User One" using the webUI
    Then file "lorem.txt" shared by "User One" should be in "Accepted" state on the webUI
    And file "testimage.jpg" shared by "User One" should be in "Pending" state on the webUI
    When the user browses to the files page
    And the user opens folder "Shares" using the webUI
    Then file "lorem.txt" should be listed on the webUI
    And file "testimage.jpg" should not be listed on the webUI

  @skip @issue-4102
  Scenario: delete an accepted share
    Given user "user1" has shared file "lorem.txt" with user "user2"
    And user "user1" has shared file "testimage.jpg" with user "user2"
    And the user has browsed to the shared-with-me page
    When the user accepts share "lorem.txt" offered by user "User One" using the webUI
    And the user browses to the files page
    And the user opens folder "Shares" using the webUI
    And the user deletes file "lorem.txt" using the webUI
    Then file "lorem.txt" should not be listed on the webUI
    And file "testimage.jpg" should not be listed on the webUI
    When the user browses to the shared-with-me page using the webUI
    Then file "lorem.txt" shared by "User One" should be in "Declined" state on the webUI
    And file "testimage.jpg" shared by "User One" should be in "Pending" state on the webUI

  @issue-3101 @skip @issue-4102
  Scenario: Delete multiple accepted shares at once from shared with me page
    Given user "user1" has been created with default attributes
    And user "user1" has shared folder "simple-folder" with user "user2"
    And user "user1" has shared file "lorem.txt" with user "user2"
    And user "user1" has shared file "data.zip" with user "user2"
    And the user has browsed to the shared-with-me page
    And the user accepts share "lorem.txt" offered by user "User One" using the webUI
    When the user batch deletes these files using the webUI
      | name          |
      | data.zip      |
      | lorem.txt |
      | simple-folder |
    Then file "data.zip" should not be listed on the webUI
    And file "lorem.txt" should not be listed on the webUI
    And folder "simple-folder" should not be listed on the webUI
    When the user has reloaded the current page of the webUI
    Then file "data.zip" shared by "User One" should be in "Declined" state on the webUI
    And file "lorem.txt" shared by "User One" should be in "Declined" state on the webUI
    And folder "simple-folder" shared by "User One" should be in "Declined" state on the webUI

  @skip @issue-4102
  Scenario: shared file status is changed to declined when user deletes the file
    Given user "user1" has shared file "lorem.txt" with user "user2"
    And user "user2" has accepted the share "lorem.txt" offered by user "user1"
    And the user has reloaded the current page of the webUI
    And the user opens folder "Shares" using the webUI
    When the user deletes file "lorem.txt" using the webUI
    And the user browses to the shared-with-me page
    Then file "lorem.txt" shared by "User One" should be in "Declined" state on the webUI

  @ocis-issue-714
  Scenario: the deleted shared file is restored back to all files list when accepted from the shared with me file list
    Given user "user1" has shared file "lorem.txt" with user "user2"
    And user "user2" has accepted the share "lorem.txt" offered by user "user1"
    And the following files have been deleted by user "user2"
      | name          |
      | Shares/lorem.txt |
    And the user has browsed to the shared-with-me page
    When the user accepts share "lorem.txt" offered by user "User One" using the webUI
    Then the file "lorem.txt" shared by "User One" should not be in "Declined" state
    When the user browses to the files page
    And the user opens folder "Shares" using the webUI
    Then file "lorem.txt" should be listed on the webUI

  @ocis-issue-713
  Scenario: receive shares with same name from different users, accept one by one
    Given user "user3" has been created with default attributes
    And user "user3" has created folder "/simple-folder/from_user3"
    And user "user3" has shared folder "/simple-folder" with user "user2"
    And user "user1" has created folder "/simple-folder/from_user1"
    And user "user1" has shared folder "/simple-folder" with user "user2"
    And the user has browsed to the shared-with-me page
    When the user accepts share "simple-folder" offered by user "User One" using the webUI
    Then folder "simple-folder" shared by "User One" should be in "Accepted" state on the webUI
    When the user accepts share "simple-folder" offered by user "User Three" using the webUI
    Then folder "simple-folder (2)" shared by "User Three" should be in "Accepted" state on the webUI
    And as "user2" file "from_user1" should exist inside folder "/Shares/simple-folder"
    And as "user2" file "from_user3" should exist inside folder "/Shares/simple-folder (2)"

  @ocis-reva-issue-34
  Scenario: accept a share that you received as user and as group member
    Given these groups have been created:
      | groupname |
      | grp1      |
    And user "user2" has been added to group "grp1"
    And user "user1" has shared folder "/simple-folder" with user "user2"
    And user "user1" has shared folder "/simple-folder" with group "grp1"
    And the user has browsed to the shared-with-me page
    When the user accepts share "simple-folder" offered by user "User One" using the webUI
    Then folder "simple-folder" shared by "User One" should be in "Accepted" state on the webUI
    When the user browses to the files page
    And the user opens folder "Shares" using the webUI
    Then folder "simple-folder" should be listed on the webUI
