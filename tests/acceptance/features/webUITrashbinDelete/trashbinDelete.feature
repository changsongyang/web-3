@files_trashbin-app-required @issue-ocis-web-118
Feature: files and folders can be deleted from the trashbin
  As a user
  I want to delete files and folders from the trashbin
  So that I can control my trashbin space and which files are kept in that space

  Background:
    Given user "user1" has been created with default attributes
    And user "user1" has created file "sample,1.txt"
    And user "user1" has created folder "Folder,With,Comma"
    And user "user1" has logged in using the webUI
    And the following files have been deleted by user "user1"
      | name              |
      | data.zip          |
      | lorem.txt         |
      | lorem-big.txt     |
      | simple-folder     |
      | sample,1.txt      |
      | Folder,With,Comma |
    And the user has browsed to the trashbin page

  @smokeTest
  @yetToImplement
  Scenario: Delete files and check that they are gone
    When the user deletes file "lorem.txt" using the webUI
    And the user deletes file "sample,1.txt" using the webUI
    # web does not yet support navigating into deleted folders
    # And the user opens folder "simple-folder" using the webUI
    # And the user deletes file "lorem-big.txt" using the webUI
    Then file "lorem.txt" should not be listed on the webUI
    Then file "sample,1.txt" should not be listed on the webUI
    # But file "lorem.txt" should be listed in the trashbin folder "simple-folder" on the webUI
    # And file "lorem-big.txt" should not be listed in the trashbin folder "simple-folder" on the webUI
    But file "lorem-big.txt" should be listed on the webUI

  @issue-product-188
  Scenario: Delete folders and check that they are gone
    When the user deletes folder "simple-folder" using the webUI
    And the user deletes folder "Folder,With,Comma" using the webUI
    Then folder "simple-folder" should not be listed on the webUI
    And folder "Folder,With,Comma" should not be listed on the webUI

  @skipOnOC10
  @issue-product-188
  # after the issue is fixed delete this scenario and use the one above
  Scenario: Delete folders and check that they are gone
    When the user deletes folder "simple-folder" using the webUI
    Then the error message with header "Deletion of simple-folder failed" should be displayed on the webUI
    And folder "simple-folder" should be listed on the webUI
    When the user deletes folder "Folder,With,Comma" using the webUI
    Then folder "Folder,With,Comma" should not be listed on the webUI

  Scenario: Select some files and delete from trashbin in a batch
    When the user batch deletes these files using the webUI
      | name          |
      | lorem.txt     |
      | lorem-big.txt |
    Then the deleted elements should not be listed on the webUI
    And the deleted elements should not be listed on the webUI after a page reload
    But file "data.zip" should be listed on the webUI
    And folder "simple-folder" should be listed on the webUI
    And the user browses to the files page
    And file "lorem.txt" should not be listed on the webUI
    And file "lorem-big.txt" should not be listed on the webUI

  @issue-product-188
  Scenario: Select all except for some files and delete from trashbin in a batch
    When the user marks all files for batch action using the webUI
    And the user unmarks these files for batch action using the webUI
      | name          |
      | lorem.txt     |
      | lorem-big.txt |
    And the user batch deletes the marked files using the webUI
    Then file "lorem.txt" should be listed on the webUI
    And file "lorem-big.txt" should be listed on the webUI
    But file "data.zip" should not be listed on the webUI
    And folder "simple-folder" should not be listed on the webUI

  @skipOnOC10
  @issue-product-188
  # after the issue is fixed delete this scenario and use the one above
  Scenario: Select all except for some files and delete from trashbin in a batch
    When the user marks all files for batch action using the webUI
    And the user unmarks these files for batch action using the webUI
      | name          |
      | lorem.txt     |
      | lorem-big.txt |
    And the user batch deletes the marked files using the webUI
    Then file "lorem.txt" should be listed on the webUI
    And file "lorem-big.txt" should be listed on the webUI
    But folder "simple-folder" should be listed on the webUI
    And file "data.zip" should not be listed on the webUI

  @issue-product-188
  Scenario: Select all files and delete from trashbin in a batch
    When the user marks all files for batch action using the webUI
    And the user batch deletes the marked files using the webUI
    Then there should be no resources listed on the webUI

  @skipOnOC10
  @issue-product-188
  # after the issue is fixed delete this scenario and use the one above
  Scenario: Select all files and delete from trashbin in a batch
    When the user marks all files for batch action using the webUI
    And the user batch deletes the marked files using the webUI
    Then file "lorem.txt" should not be listed on the webUI
    But folder "simple-folder" should be listed on the webUI

  @issue-4437
  Scenario: Delete single file from deleted files list
    When the user deletes the file "lorem.txt" from the deleted files list
    Then file "lorem.txt" should not be listed on the webUI
    When the user reloads the current page of the webUI
    Then file "lorem.txt" should not be listed on the webUI

  @issue-product-139
  Scenario: Clear trashbin
    When the user clears the trashbin
    Then the success message with header "All deleted files were removed" should be displayed on the webUI
    And there should be no resources listed on the webUI

  @skipOnOC10
  @issue-product-139
  # after the issue is fixed delete this scenario and use the one above
  Scenario: Clear trashbin
    When the user clears the trashbin
    Then the error message with header "Could not delete files" should be displayed on the webUI
    And file "lorem.txt" should be listed on the webUI
    And folder "simple-folder" should be listed on the webUI
