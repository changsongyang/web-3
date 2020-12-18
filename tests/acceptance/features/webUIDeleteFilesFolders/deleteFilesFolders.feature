Feature: deleting files and folders
  As a user
  I want to delete files and folders
  So that I can keep my filing system clean and tidy

  Background:
    Given user "user1" has been created with default attributes
    And user "user1" has logged in using the webUI
    And the user has browsed to the files page

  @smokeTest @ocisSmokeTest
  Scenario: Delete files & folders one by one and check its existence after page reload
    Given user "user1" has created file "sample,1.txt"
    And user "user1" has created folder "Sample,Folder,With,Comma"
    And the user has reloaded the current page of the webUI
    When the user deletes the following elements using the webUI
      | name                                  |
      | simple-folder                         |
      | lorem.txt                             |
      | strängé नेपाली folder                   |
      | strängé filename (duplicate #2 &).txt |
      | sample,1.txt                          |
      | Sample,Folder,With,Comma              |
    Then as "user1" folder "simple-folder" should not exist
    And as "user1" file "lorem.txt" should not exist
    And as "user1" folder "strängé नेपाली folder" should not exist
    And as "user1" file "strängé filename (duplicate #2 &).txt" should not exist
    And as "user1" file "sample,1.txt" should not exist
    And as "user1" folder "Sample,Folder,With,Comma" should not exist
    And no message should be displayed on the webUI
    And the deleted elements should not be listed on the webUI
    But folder "simple-empty-folder" should be listed on the webUI
    And file "lorem-big.txt" should be listed on the webUI
    And file "strängé नेपाली folder" should not be listed on the webUI
    But the deleted elements should not be listed on the webUI after a page reload

  Scenario Outline: Delete a file with problematic characters
    Given user "user1" has created file <file_name>
    When the user reloads the current page of the webUI
    And the user deletes file <file_name> using the webUI
    Then file <file_name> should not be listed on the webUI
    When the user reloads the current page of the webUI
    Then file <file_name> should not be listed on the webUI
    Examples:
      | file_name           |
      | "'single'"          |
      | "\"double\" quotes" |
      | "question?"         |
      | "&and#hash"         |

  @smokeTest
  Scenario: Delete multiple files at once
    When the user batch deletes these files using the webUI
      | name          |
      | data.zip      |
      | lorem.txt     |
      | simple-folder |
    Then as "user1" file "data.zip" should not exist
    And as "user1" file "lorem.txt" should not exist
    And as "user1" folder "simple-folder" should not exist
    And the deleted elements should not be listed on the webUI
    And the deleted elements should not be listed on the webUI after a page reload
    And no message should be displayed on the webUI

  @ocis-issue-532
  Scenario: Delete all files at once
    When the user marks all files for batch action using the webUI
    And the user batch deletes the marked files using the webUI
    # Check just some example files/folders that should not exist any more
    Then as "user1" file "data.zip" should not exist
    And as "user1" file "lorem.txt" should not exist
    And as "user1" folder "simple-folder" should not exist
    And there should be no resources listed on the webUI
    And there should be no resources listed on the webUI after a page reload
    And no message should be displayed on the webUI

  @ocis-reva-issue-106 @ocis-reve-issue-442
  Scenario: Delete all except for a few files at once
    When the user marks all files for batch action using the webUI
    And the user unmarks these files for batch action using the webUI
      | name          |
      | lorem.txt     |
      | simple-folder |
    And the user batch deletes the marked files using the webUI
    Then as "user1" file "lorem.txt" should exist
    And as "user1" folder "simple-folder" should exist
    And folder "simple-folder" should be listed on the webUI
    And file "lorem.txt" should be listed on the webUI
    # Check just an example of a file that should not exist any more
    But as "user1" file "data.zip" should not exist
    And file "data.zip" should not be listed on the webUI
    And the count of files and folders shown on the webUI should be 2
    And no message should be displayed on the webUI

  @ocis-reva-issue-106
  Scenario: Delete an empty folder
    When the user creates a folder with the name "my-empty-folder" using the webUI
    And the user creates a folder with the name "my-other-empty-folder" using the webUI
    And the user deletes folder "my-empty-folder" using the webUI
    Then as "user1" folder "my-other-empty-folder" should exist
    And folder "my-other-empty-folder" should be listed on the webUI
    But as "user1" folder "my-empty-folder" should not exist
    And folder "my-empty-folder" should not be listed on the webUI
    And no message should be displayed on the webUI

  Scenario: Delete the last file in a folder
    When the user deletes file "zzzz-must-be-last-file-in-folder.txt" using the webUI
    Then as "user1" file "zzzz-must-be-last-file-in-folder.txt" should not exist
    And file "zzzz-must-be-last-file-in-folder.txt" should not be listed on the webUI
    And no message should be displayed on the webUI

  @skip @yetToImplement
  @public_link_share-feature-required
  Scenario: delete files from shared by link page
    Given the user has created a new public link for file "lorem.txt" using the webUI
    And the user has browsed to the shared-by-link page
    Then file "lorem.txt" should be listed on the webUI
    When the user deletes file "lorem.txt" using the webUI
    Then as "user1" file "lorem.txt" should not exist
    And file "lorem.txt" should not be listed on the webUI
    When the user browses to the files page
    Then file "lorem.txt" should not be listed on the webUI

  @skip @yetToImplement
  @systemtags-app-required
  Scenario: delete files from tags page
    Given user "user1" has created a "normal" tag with name "lorem"
    And user "user1" has added tag "lorem" to file "/lorem.txt"
    When the user browses to the tags page
    And the user searches for tag "lorem" using the webUI
    Then file "lorem.txt" should be listed on the webUI
    When the user deletes file "lorem.txt" using the webUI
    Then as "user1" file "lorem.txt" should not exist
    And file "lorem.txt" should not be listed on the webUI
    When the user browses to the files page
    Then file "lorem.txt" should not be listed on the webUI

  @ocis-reva-issue-64
  Scenario: delete a file on a public share
    Given user "user1" has shared folder "simple-folder" with link with "read, update, create, delete" permissions
    When the public uses the webUI to access the last public link created by user "user1"
    And the user deletes the following elements using the webUI
      | name                                  |
      | simple-empty-folder                   |
      | lorem.txt                             |
      | strängé filename (duplicate #2 &).txt |
    Then as "user1" file "simple-folder/lorem.txt" should not exist
    And as "user1" folder "simple-folder/simple-empty-folder" should not exist
    And as "user1" file "simple-folder/strängé filename (duplicate #2 &).txt" should not exist
    And the deleted elements should not be listed on the webUI
    And no message should be displayed on the webUI
    And the deleted elements should not be listed on the webUI after a page reload

  @ocis-reva-issue-64
  Scenario: delete a file on a public share with problematic characters
    Given user "user1" has renamed the following file
      | from-name-parts          | to-name-parts   |
      | lorem.txt                | simple-folder/  |
      |                          | 'single'        |
      |                          | "double" quotes |
      |                          | question?       |
      |                          | &and#hash       |
    And user "user1" has shared folder "simple-folder" with link with "read, update, create, delete" permissions
    When the public uses the webUI to access the last public link created by user "user1"
    And the user deletes the following file using the webUI
      | name-parts      |
      | 'single'        |
      | "double" quotes |
      | question?       |
      | &and#hash       |
    Then the following file should not be listed on the webUI
      | name-parts      |
      | 'single'        |
      | "double" quotes |
      | question?       |
      | &and#hash       |
    And no message should be displayed on the webUI
    When the user reloads the current page of the webUI
    Then the following file should not be listed on the webUI
      | name-parts      |
      | 'single'        |
      | "double" quotes |
      | question?       |
      | &and#hash       |

  @skip @yetToImplement
  Scenario: Delete multiple files at once on a public share
    Given user "user1" has shared folder "simple-folder" with link with "read, update, create, delete" permissions
    When the public uses the webUI to access the last public link created by user "user1"
    And the user batch deletes these files using the webUI
      | name                |
      | data.zip            |
      | lorem.txt           |
      | simple-empty-folder |
    Then as "user1" file "simple-folder/data.zip" should not exist
    And as "user1" file "simple-folder/lorem.txt" should not exist
    And as "user1" folder "simple-folder/simple-empty-folder" should not exist
    And the deleted elements should not be listed on the webUI
    And the deleted elements should not be listed on the webUI after a page reload

  @ocis-reva-issue-64
  Scenario: Delete a file and folder from shared with me page
    Given user "user2" has been created with default attributes
    And user "user2" has shared folder "simple-folder" with user "user1"
    And user "user2" has shared file "lorem.txt" with user "user1"
    And the user has browsed to the shared-with-me page
    When the user deletes folder "simple-folder (2)" using the webUI
    And the user deletes file "lorem (2).txt" using the webUI
    Then as "user1" folder "simple-folder (2)" should not exist
    And as "user1" file "lorem (2).txt" should not exist
    And no message should be displayed on the webUI

  @ocis-reva-issue-64
  Scenario: Delete a file and folder in shared with others page
    Given user "user2" has been created with default attributes
    And user "user1" has shared file "lorem.txt" with user "user2"
    And user "user1" has shared folder "simple-folder" with user "user2"
    When the user browses to the shared-with-others page
    And the user deletes folder "simple-folder" using the webUI
    And the user deletes file "lorem.txt" using the webUI
    Then file "lorem.txt" should not be listed on the webUI
    And folder "simple-folder" should not be listed on the webUI
    And no message should be displayed on the webUI
    When the user reloads the current page of the webUI
    Then file "lorem.txt" should not be listed on the webUI
    And folder "simple-folder" should not be listed on the webUI
    When the user browses to the files page
    Then file "lorem.txt" should not be listed on the webUI
    And folder "simple-folder" should not be listed on the webUI
    And as "user1" file "lorem.txt" should not exist
    And as "user1" folder "simple-folder" should not exist

  @ocis-reva-issue-64
  Scenario: Delete multiple files at once from shared with others page
    Given user "user2" has been created with default attributes
    And user "user1" has shared file "lorem.txt" with user "user2"
    And user "user1" has shared folder "simple-folder" with user "user2"
    And user "user1" has shared file "data.zip" with user "user2"
    And the user has browsed to the shared-with-others page
    When the user batch deletes these files using the webUI
      | name          |
      | data.zip      |
      | lorem.txt     |
      | simple-folder |
    Then as "user1" file "data.zip" should not exist
    And as "user1" file "lorem.txt" should not exist
    And as "user1" folder "simple-folder" should not exist
    And the deleted elements should not be listed on the webUI
    And no message should be displayed on the webUI
    And the deleted elements should not be listed on the webUI after a page reload

  @ocis-reva-issue-39
  Scenario: Try to delete file and folder from favorites page
    Given user "user1" has favorited element "simple-folder"
    And user "user1" has favorited element "lorem.txt"
    When the user browses to the favorites page
    And the user deletes file "lorem.txt" using the webUI
    And the user deletes folder "simple-folder" using the webUI
    Then file "lorem.txt" should not be listed on the webUI
    And folder "simple-folder" should not be listed on the webUI

  Scenario: Try to delete file and folder that used to exist but does not anymore
    Given the user has browsed to the files page
    And the following files have been deleted by user "user1"
      | name          |
      | lorem.txt     |
      | simple-folder |
    When the user deletes file "lorem.txt" using the webUI
    Then the error message with header 'Error while deleting "lorem.txt"' should be displayed on the webUI
    When the user clears all error message from the webUI
    And the user deletes folder "simple-folder" using the webUI
    Then the error message with header 'Error while deleting "simple-folder"' should be displayed on the webUI
    When the user reloads the current page of the webUI
    Then file "lorem.txt" should not be listed on the webUI
    And folder "simple-folder" should not be listed on the webUI
    And as "user1" file "lorem.txt" should not exist
    And as "user1" folder "simple-folder" should not exist
