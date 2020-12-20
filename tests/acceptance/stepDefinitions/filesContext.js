/* eslint-disable no-unused-expressions */
const { client } = require('nightwatch-api')
const assert = require('assert')
const { Given, When, Then, Before } = require('cucumber')
const webdav = require('../helpers/webdavHelper')
const _ = require('lodash')
const loginHelper = require('../helpers/loginHelper')
const xpathHelper = require('../helpers/xpath')
const { move } = require('../helpers/webdavHelper')
const path = require('../helpers/path')
const util = require('util')
let deletedElements
const { download } = require('../helpers/webdavHelper')
const fs = require('fs')

Before(() => {
  deletedElements = []
})

When('the user browses to the files page', () => {
  return client.page.filesPage().navigateAndWaitTillLoaded()
})

When('the user browses to the favorites page', function() {
  return client.page.favoritesPage().navigateAndWaitTillLoaded()
})

Given('the user has browsed to the favorites page', function() {
  return client.page.favoritesPage().navigateAndWaitTillLoaded()
})

When('the user browses to the shared-with-me page', function() {
  return client.page.sharedWithMePage().navigateAndWaitTillLoaded()
})

Given('the user has browsed to the shared-with-me page', function() {
  return client.page.sharedWithMePage().navigateAndWaitTillLoaded()
})

Given('the user has browsed to the shared-with-others page', function() {
  return client.page.sharedWithOthersPage().navigateAndWaitTillLoaded()
})

When('the user browses to the shared-with-me page using the webUI', function() {
  return client.page.webPage().navigateToUsingMenu('Shared with me')
})

When('the user browses to the shared-with-others page', function() {
  return client.page.sharedWithOthersPage().navigateAndWaitTillLoaded()
})

When('the user browses to the shared-with-others page using the webUI', function() {
  return client.page.webPage().navigateToUsingMenu('Shared with others')
})

Given('the user has browsed to the trashbin page', function() {
  return client.page.trashbinPage().navigateAndWaitTillLoaded()
})

When('the user browses to the trashbin page', function() {
  return client.page.trashbinPage().navigateAndWaitTillLoaded()
})

Given('the user has browsed to the favorites page using the webUI', function() {
  return client.page.webPage().navigateToUsingMenu('Favorites')
})

When('the user browses to the favorites page using the webUI', function() {
  return client.page.webPage().navigateToUsingMenu('Favorites')
})

When('the user browses to the files page using the webUI', function() {
  return client.page.webPage().navigateToUsingMenu('All files')
})

Then('the files table should be displayed', () => {
  return client.page.FilesPageElement.filesList().waitForElementVisible('@filesTable')
})

Given('the user has browsed to the files page', async function() {
  await client.page.filesPage().navigateAndWaitTillLoaded()
})

When('the user opens folder {string} directly on the webUI', async function(folder) {
  folder = encodeURIComponent(path.normalize(folder))
  await client.page.filesPage().navigateAndWaitTillLoaded(folder)
  await client.page.FilesPageElement.filesList().waitForAllThumbnailsLoaded()
})

Given('user {string} has uploaded file with content {string} to {string}', async function(
  user,
  content,
  filename
) {
  await webdav.createFile(user, filename, content)
})

Given('user {string} has uploaded file {string} to {string}', async function(
  user,
  source,
  filename
) {
  const filePath = path.join(client.globals.filesForUpload, source)
  const content = fs.readFileSync(filePath)
  await webdav.createFile(user, filename, content)
})

When('the user browses to display the {string} details of file {string}', async function(
  accordionItem,
  filename
) {
  const api = client.page.FilesPageElement
  await api.filesList().clickRow(filename)
  await client.initAjaxCounters()
  await api.appSideBar().selectAccordionItem(accordionItem)
  await client.waitForOutstandingAjaxCalls()

  return client
})

Given('user {string} has moved file/folder {string} to {string}', function(user, fromName, toName) {
  return move(user, fromName, toName)
})

When('the user creates a folder with the name {string} using the webUI', function(folderName) {
  return client.page.filesPage().createFolder(folderName)
})

When('the user creates a file with the name {string} using the webUI', function(fileName) {
  return client.page.filesPage().createFile(fileName)
})

When('the user creates a folder with default name using the webUI', function() {
  return client.page.filesPage().createFolder(null, false)
})

When('the user creates a folder without name using the webUI', function() {
  return client.page.filesPage().createFolder('', false)
})

When('the user creates a folder with the invalid name {string} using the webUI', function(
  folderName
) {
  return client.page.filesPage().createFolder(folderName, false)
})

Given('the user has opened folder {string}', folder =>
  client.page.FilesPageElement.filesList().navigateToFolder(folder)
)
When('the user opens folder {string} using the webUI', folder =>
  client.page.FilesPageElement.filesList().navigateToFolder(folder)
)

Given('the user has opened the share dialog for file/folder {string}', function(fileName) {
  return client.page.FilesPageElement.appSideBar()
    .closeSidebar(100)
    .openSharingDialog(fileName)
})

When('the user closes the app-sidebar using the webUI', function() {
  return client.page.FilesPageElement.appSideBar().closeSidebar(100)
})

When('the user browses to folder {string} using the breadcrumb on the webUI', resource =>
  client.page.filesPage().navigateToBreadcrumb(resource)
)

When('the user deletes file/folder {string} using the webUI', function(element) {
  return client.page.FilesPageElement.filesList().deleteFile(element)
})

Given('the user has deleted file/folder/resource {string} using the webUI', function(element) {
  return client.page.FilesPageElement.filesList().deleteFile(element)
})

When('the user deletes the following elements using the webUI', async function(table) {
  for (const line of table.rows()) {
    await client.page.FilesPageElement.filesList().deleteFile(line[0])
    deletedElements.push(line[0])
  }
  return client.page.filesPage()
})

Then('there should be no breadcrumb displayed on the webUI', function() {
  return assertBreadCrumbIsNotDisplayed()
})

Then('non-clickable breadcrumb for folder {string} should be displayed on the webUI', function(
  resource
) {
  return assertBreadcrumbIsDisplayedFor(resource, false, true)
})

Then('clickable breadcrumb for folder {string} should be displayed on the webUI', function(
  resource
) {
  return assertBreadcrumbIsDisplayedFor(resource, true, false)
})

Then('breadcrumb for folder {string} should be displayed on the webUI', function(resource) {
  return assertBreadcrumbIsDisplayedFor(resource, true, true)
})

Given('the following files/folders/resources have been deleted by user {string}', async function(
  user,
  table
) {
  const filesToDelete = table.hashes()
  for (const entry of filesToDelete) {
    await webdav.delete(user, entry.name)
  }
  return client
})

When('the user/public uploads file {string} using the webUI', function(element) {
  const uploadPath = path.join(client.globals.mountedUploadDir, element)
  return client.page.filesPage().uploadFile(uploadPath)
})

When('the user uploads a created file {string} using the webUI', function(element) {
  const filePath = path.join(client.globals.filesForUpload, element)
  return client.uploadRemote(filePath, function(uploadPath) {
    client.page.filesPage().uploadFile(uploadPath)
  })
})

When('the public uploads file {string} in files-drop page', function(element) {
  const rootUploadDir = client.globals.mountedUploadDir
  const filePath = path.join(rootUploadDir, element)
  return client.page
    .filesDropPage()
    .initAjaxCounters()
    .uploadFile(filePath)
    .waitForOutstandingAjaxCalls()
})

Then('the following files should be listed on the files-drop page:', async function(filesToCheck) {
  filesToCheck = filesToCheck.raw().map(([file]) => file)

  const actualFiles = await client.page.filesDropPage().getUploadedFiles()
  const filesNotUploaded = _.difference(filesToCheck, actualFiles)
  assert.strictEqual(
    filesNotUploaded.length,
    0,
    'Could not find following files: \n' + filesNotUploaded
  )
})

When('the user unshares file/folder {string} using the webUI', function(element) {
  return client.page.FilesPageElement.filesList().deleteFile(element)
})

When('the user uploads folder {string} using the webUI', function(element) {
  const rootUploadDir = client.globals.mountedUploadDir
  const name = path.join(rootUploadDir, element)
  return client.page.filesPage().uploadFolder(name)
})

When(
  'the user uploads a folder containing the following files in separate sub-folders using the webUI:',
  async function(files) {
    files = files.raw().map(item => item[0])

    if (new Set(files).size !== files.length) {
      throw new Error(
        `Allowing upload of multiple files in the same folder would complicate
      other step-definitions. Please remove duplicated files and retry.`
      )
    }

    if (files.length === 1) {
      throw new Error(
        'Please try uploading more than one file. Uploading only one file is not supported.'
      )
    }

    for (const file of files) {
      const filePath = path.join(client.globals.filesForUpload, file)
      await client.uploadRemote(filePath)
    }
    return client.page.filesPage().uploadSessionFolder()
  }
)

Then('it should not be possible to create files using the webUI', function() {
  return client.page.filesPage().canCreateFiles(async isDisabled => {
    await assert.strictEqual(isDisabled, true, 'Create action must not be enabled')
  })
})

Then('it should be possible to create files using the webUI', function() {
  return client.page.filesPage().canCreateFiles(async isDisabled => {
    await assert.strictEqual(isDisabled, false, 'Create action must be enabled')
  })
})

When('the user renames file/folder {string} to {string} using the webUI', function(
  fromName,
  toName
) {
  return client.page.FilesPageElement.filesList().renameFile(fromName, toName)
})

When('the user tries to rename file/folder {string} to {string} using the webUI', function(
  fromName,
  toName
) {
  return client.page.FilesPageElement.filesList().renameFile(fromName, toName, false)
})

When('the user renames the following file/folder using the webUI', async function(dataTable) {
  for (const { fromName, toName } of dataTable.hashes()) {
    await client.page.FilesPageElement.filesList().renameFile(fromName, toName)
  }
  return client
})

Given('the user has marked file/folder {string} as favorite using the webUI', function(path) {
  return client.page.FilesPageElement.filesList().markFavorite(path)
})

When('the user marks file/folder {string} as favorite using the webUI', function(path) {
  return client.page.FilesPageElement.filesList().markFavorite(path)
})

When('the user unmarks the favorited file/folder {string} using the webUI', function(path) {
  return client.page.FilesPageElement.filesList().unmarkFavorite(path)
})

When('the user marks file/folder {string} as favorite using the webUI sidebar', async function(
  path
) {
  const api = client.page.FilesPageElement
  await api.filesList().clickRow(path)
  api.appSideBar().markFavoriteSidebar()
  return client
})

When('the user unmarks the favorited file/folder {string} using the webUI sidebar', async function(
  path
) {
  const api = client.page.FilesPageElement
  await api.filesList().clickRow(path)
  api.appSideBar().unmarkFavoriteSidebar()
  return client
})

Then('there should be no files/folders/resources listed on the webUI', assertNoResourcesListed)
Then(
  'there should be no files/folders/resources listed on the webUI after a page reload',
  async function() {
    await client.refresh()
    return assertNoResourcesListed()
  }
)

async function assertNoResourcesListed() {
  let currentUrl = null
  await client.url(result => {
    currentUrl = result.value
  })

  // only check empty message in regular file lists, not files drop page
  if (currentUrl.indexOf('/files-drop/') === -1) {
    const noContentMessageVisible = await client.page.FilesPageElement.filesList().isNoContentMessageVisible()
    assert.ok(noContentMessageVisible, 'Empty message must be visible')
  }

  const allRowsResult = await client.page.FilesPageElement.filesList().allFileRows()

  return assert.ok(
    allRowsResult.value.length === 0,
    `No resources are listed, ${allRowsResult.length} found`
  )
}

Then('there should be a not found error page displayed on the webUI', async function() {
  const notFoundMessageVisible = await client.page.FilesPageElement.filesList().isNotFoundMessageVisible()
  assert.ok(notFoundMessageVisible, 'NotFound message must be visible')
})

Then('file {string} should be listed on the webUI', function(folder) {
  return client.page.FilesPageElement.filesList().waitForFileVisible(folder, 'file')
})

Then('folder {string} should be listed on the webUI', folder => {
  return client.page.FilesPageElement.filesList().waitForFileVisible(folder, 'folder')
})

Then('file/folder with path {string} should be listed in the favorites page on the webUI', function(
  path
) {
  return client.page.FilesPageElement.filesList().waitForFileWithPathVisible(path)
})

Then('the last uploaded folder should be listed on the webUI', async function() {
  const folder = client.sessionId
  await client.page.FilesPageElement.filesList().waitForFileVisible(folder)

  return client
})

Then('file {string} should not be listed on the webUI', function(file) {
  return client.page.FilesPageElement.filesList()
    .isElementListed(file, 'file', client.globals.waitForNegativeConditionTimeout)
    .then(state => {
      const message = state
        ? `Error: File '${file}' is listed on the filesList`
        : `File '${file}' is not listed on the filesList`
      return client.assert.ok(!state, message)
    })
})

Then('folder {string} should not be listed on the webUI', folder => {
  return client.page.FilesPageElement.filesList()
    .isElementListed(folder, 'folder', client.globals.waitForNegativeConditionTimeout)
    .then(state => {
      const message = state
        ? `Error: Folder '${folder}' is listed on the filesList`
        : `Folder '${folder}' is not listed on the filesList`
      return client.assert.ok(!state, message)
    })
})

Then('the deleted elements should not be listed on the webUI', function() {
  return assertDeletedElementsAreNotListed()
})

Then('the deleted elements should not be listed on the webUI after a page reload', function() {
  client.refresh()
  return assertDeletedElementsAreNotListed()
})

Then('the versions list should contain {int} entries', async function(expectedNumber) {
  const count = await client.page.FilesPageElement.versionsDialog().getVersionsCount()
  return assert.strictEqual(count, expectedNumber)
})

Then('the versions list for resource {string} should contain {int} entry/entries', async function(
  resourceName,
  expectedNumber
) {
  const api = client.page.FilesPageElement
  await api.filesList().clickRow(resourceName)
  await client.initAjaxCounters()
  await api.appSideBar().selectAccordionItem('versions')
  await client.waitForOutstandingAjaxCalls()
  const count = await api.versionsDialog().getVersionsCount()

  assert.strictEqual(count, expectedNumber)

  client.page.FilesPageElement.appSideBar().closeSidebar(100)

  return this
})

Then('the content of file {string} for user {string} should be {string}', async function(
  file,
  user,
  content
) {
  const remote = await download(user, file)
  return client.assert.strictEqual(
    remote,
    content,
    `Failed asserting remote file ${file} is same as content ${content} for user${user}`
  )
})

When('the user restores the file to last version using the webUI', function() {
  return client.page.FilesPageElement.versionsDialog().restoreToPreviousVersion()
})

When('the user reloads the current page of the webUI', function() {
  return client.refresh()
})

Given('the user has reloaded the current page of the webUI', function() {
  return client.refresh()
})

When('the user marks all files for batch action using the webUI', function() {
  return client.page.FilesPageElement.filesList().checkAllFiles()
})

When('the user batch deletes the marked files using the webUI', function() {
  return client.page.filesPage().deleteAllCheckedFiles()
})

When('the user batch deletes these files using the webUI', async function(fileOrFolders) {
  for (const item of fileOrFolders.rows()) {
    await client.page.FilesPageElement.filesList().toggleFileOrFolderCheckbox('enable', item[0])
    deletedElements.push(item[0])
  }

  return client.page.filesPage().deleteAllCheckedFiles()
})

When('the user unmarks these files for batch action using the webUI', async function(
  fileOrFolders
) {
  for (const item of fileOrFolders.rows()) {
    await client.page.FilesPageElement.filesList().toggleFileOrFolderCheckbox('disable', item[0])
  }
})

When('the user marks these files for batch action using the webUI', async function(fileOrFolders) {
  for (const item of fileOrFolders.rows()) {
    await client.page.FilesPageElement.filesList().toggleFileOrFolderCheckbox('enable', item[0])
  }
})

When('the user clears the trashbin', function() {
  return client.page.trashbinPage().clearTrashbin()
})

When('the user batch restores the marked files using the webUI', function() {
  return client.page.FilesPageElement.filesList().restoreSelected()
})

When('the user picks the row of file/folder {string} in the webUI', function(item) {
  return client.page.FilesPageElement.filesList().clickRow(item)
})

When('the user switches to {string} accordion item in details panel using the webUI', function(
  item
) {
  return client.page.FilesPageElement.appSideBar().selectAccordionItem(item)
})

const theseResourcesShouldNotBeListed = async function(table) {
  for (const entry of table.rows()) {
    const state = await client.page.FilesPageElement.filesList().isElementListed(
      entry[0],
      'file',
      client.globals.waitForNegativeConditionTimeout
    )
    assert.ok(!state, `Expected resource '${entry[0]}' to be 'not present' but found 'present'`)
  }
}

/**
 * needs a heading line in the table
 */
Then('these folders/files/resources should not be listed on the webUI', function(table) {
  return theseResourcesShouldNotBeListed(table)
})

/**
 * needs a heading line in the table
 */
Then('as {string} these folders/files/resources should not be listed on the webUI', async function(
  user,
  entryList
) {
  if (user !== client.globals.currentUser) {
    await loginHelper.reLoginAsUser(user)
  }
  return theseResourcesShouldNotBeListed(entryList)
})

/**
 * currently this only works with the files page, on other pages the user cannot navigate into subfolders
 *
 * needs a heading line in the table
 */
Then(
  'these folders/files/resources should not be listed in the folder {string} on the webUI',
  async function(folder, entryList) {
    await client.page.filesPage().navigateAndWaitTillLoaded(folder)
    return theseResourcesShouldNotBeListed(entryList)
  }
)

/**
 * currently this only works with the files page, on other pages the user cannot navigate into subfolders
 *
 * needs a heading line in the table
 */
Then(
  'as {string} these folders/files/resources should not be listed in the folder {string} on the webUI',
  async function(user, folder, entryList) {
    if (user !== client.globals.currentUser) {
      await loginHelper.reLoginAsUser(user)
    }
    await client.page.filesPage().navigateAndWaitTillLoaded(folder)
    return theseResourcesShouldNotBeListed(entryList)
  }
)

/**
 *
 * @param {DataTable} entryList the list needs a heading line
 */
const theseResourcesShouldBeListed = async function(entryList) {
  if (entryList.rows().length <= 0) {
    throw Error('Gherkin entry list is empty. Missing heading?')
  }

  for (const item of entryList.rows()) {
    await client.page.FilesPageElement.filesList().waitForFileVisible(item[0])
  }

  return client
}

const assertBreadCrumbIsNotDisplayed = function() {
  const breadcrumbXpath = client.page.filesPage().elements.breadcrumb.selector
  return client.expect.element(breadcrumbXpath).to.not.be.present
}

/**
 *
 * @param {string} resource
 * @param {boolean} clickable
 * @param {boolean} nonClickable
 */
const assertBreadcrumbIsDisplayedFor = async function(resource, clickable, nonClickable) {
  const breadcrumbElement = client.page.filesPage().getBreadcrumbSelector(clickable, nonClickable)
  const resourceBreadcrumbXpath = util.format(
    breadcrumbElement.selector,
    xpathHelper.buildXpathLiteral(resource)
  )
  let isBreadcrumbVisible = false

  // lets hope that the breadcrumbs would not take longer than the "NEW" button
  await client.waitForElementVisible({
    selector: client.page.filesPage().elements.newFileMenuButtonAnyState.selector,
    abortOnFailure: false
  })

  await client.page.filesPage().checkBreadcrumbVisibility(resourceBreadcrumbXpath)

  await client.element('xpath', resourceBreadcrumbXpath, result => {
    if (result.status > -1) {
      isBreadcrumbVisible = true
    }
  })

  // Try to look for a mobile breadcrumbs in case it has not been found
  if (!isBreadcrumbVisible) {
    const mobileBreadcrumbMobileXpath = util.format(
      client.page.filesPage().elements.breadcrumbMobile.selector,
      xpathHelper.buildXpathLiteral(resource)
    )

    await client.element('xpath', mobileBreadcrumbMobileXpath, result => {
      if (result.status > -1) {
        isBreadcrumbVisible = true
      }
    })
  }

  return client.assert.strictEqual(
    isBreadcrumbVisible,
    true,
    `Resource ${resourceBreadcrumbXpath} expected to be visible but is not visible .`
  )
}

/**
 * needs a heading line in the table
 */
Then('these files/folders/resources should be listed on the webUI', function(entryList) {
  return theseResourcesShouldBeListed(entryList)
})

/**
 * currently this only works with the files page, on other pages the user cannot navigate into subfolders
 *
 * needs a heading line in the table
 */
Then(
  'these files/folders/resources should be listed in the folder {string} on the webUI',
  async function(folder, entryList) {
    await client.page.filesPage().navigateAndWaitTillLoaded(folder)
    return theseResourcesShouldBeListed(entryList)
  }
)

/**
 * needs a heading line in the table
 */
Then('as {string} these files/folders/resources should be listed on the webUI', async function(
  user,
  entryList
) {
  if (user !== client.globals.currentUser) {
    await loginHelper.reLoginAsUser(user)
  }
  return theseResourcesShouldBeListed(entryList)
})

/**
 * currently this only works with the files page, on other pages the user cannot navigate into subfolders
 *
 * needs a heading line in the table
 */
Then(
  'as {string} these files/folders/resources should be listed in the folder {string} on the webUI',
  async function(user, folder, entryList) {
    if (user !== client.globals.currentUser) {
      await loginHelper.reLoginAsUser(user)
    }
    await client.page.filesPage().navigateAndWaitTillLoaded(folder)
    return theseResourcesShouldBeListed(entryList)
  }
)

Then('as user {string} file/folder {string} should be marked as favorite', async function(
  userId,
  path
) {
  let isFavorite = await webdav.getProperties(path, userId, ['oc:favorite'])
  isFavorite = isFavorite['oc:favorite']

  return assert.strictEqual(isFavorite, '1', `${path} expected to be favorite but was not`)
})

Then('as user {string} file/folder {string} should not be marked as favorite', async function(
  userId,
  path
) {
  let isFavorite = await webdav.getProperties(path, userId, ['oc:favorite'])
  isFavorite = isFavorite['oc:favorite']

  return assert.strictEqual(isFavorite, '0', `not expected ${path} to be favorite but was`)
})

Then('file/folder {string} should be marked as favorite on the webUI', async function(path) {
  const selector = client.page.FilesPageElement.appSideBar().elements.favoriteStarShining
  await client.page.FilesPageElement.filesList().clickRow(path)

  client.expect.element(selector).to.be.visible
  client.page.FilesPageElement.appSideBar().closeSidebar()

  return client
})

Then('file/folder {string} should not be marked as favorite on the webUI', async function(path) {
  const selector = client.page.FilesPageElement.appSideBar().elements.favoriteStarDimm
  await client.page.FilesPageElement.filesList().clickRow(path)

  client.expect.element(selector).to.be.visible
  client.page.FilesPageElement.appSideBar().closeSidebar()

  return client
})

Then(/the count of files and folders shown on the webUI should be (\d+)/, async function(
  noOfItems
) {
  const itemsCount = await client.page.FilesPageElement.filesList().countFilesAndFolders()
  return client.assert.equal(itemsCount, noOfItems)
})

Then('the app-sidebar should be visible', async function() {
  const visible = await client.page.filesPage().isSidebarVisible()
  assert.strictEqual(visible, true, 'app-sidebar should be visible, but is not')
})

Then('the app-sidebar should be invisible', async function() {
  const visible = await client.page
    .filesPage()
    .isSidebarVisible(client.globals.waitForNegativeConditionTimeout)
  assert.strictEqual(visible, false, 'app-sidebar should be invisible, but is not')
})

Then('the {string} details panel should be visible', async function(panel) {
  const visible = await client.page.FilesPageElement.appSideBar().isPanelVisible(panel)
  assert.strictEqual(visible, true, `'${panel}-panel' should be visible, but is not`)
})

Then(
  'the following accordion items should be visible in the details dialog on the webUI',
  async function(table) {
    const visibleItems = await client.page.FilesPageElement.appSideBar().getVisibleAccordionItems()
    const expectedVisibleItems = table.rows()
    const difference = _.difference(expectedVisibleItems.flat(), visibleItems)
    if (difference.length !== 0) {
      throw new Error(`${difference} accordion items was expected to be visible but not found.`)
    }
  }
)

const assertElementsAreListed = async function(elements) {
  for (const element of elements) {
    const state = await client.page.FilesPageElement.filesList().isElementListed(element)
    assert.ok(state, `Expected resource '${element}' to be 'present' but found 'not present'`)
  }
  return client
}

const assertElementsAreNotListed = async function(elements) {
  for (const element of elements) {
    const state = await client.page.FilesPageElement.filesList().isElementListed(
      element,
      'file',
      client.globals.waitForNegativeConditionTimeout
    )
    assert.ok(!state, `Expected resource '${element}' to be 'not present' but found 'present'`)
  }
  return client
}

const assertDeletedElementsAreNotListed = function() {
  return assertElementsAreNotListed(deletedElements)
}

const assertDeletedElementsAreListed = function() {
  return assertElementsAreListed(deletedElements)
}

When(/^the user restores (file|folder) "([^"]*)" from the trashbin using the webUI$/, function(
  elementType,
  element
) {
  return client.page.FilesPageElement.filesList().restoreFile(element, elementType)
})

Then('the following files/folders/resources should be listed on the webUI', function(table) {
  return assertElementsAreListed([].concat.apply([], table.rows()))
})

Then('file/folder {string} should be listed in the folder {string} on the webUI', async function(
  file,
  folder
) {
  const api = client.page.FilesPageElement.filesList()

  await api.navigateToFolder(folder)

  await api.waitForFileVisible(file)

  return client
})

Then('the deleted elements should be listed on the webUI', function() {
  return assertDeletedElementsAreListed()
})

Given('user {string} has renamed the following files', function(userId, table) {
  return Promise.all(
    table.hashes().map(row => {
      return webdav.move(userId, row['from-name-parts'], row['to-name-parts'])
    })
  )
})

Given('user {string} has renamed file/folder {string} to {string}', webdav.move)

Given('user {string} has created folder {string}', webdav.createFolder)

Then(
  'file/folder {string} should not be listed in shared-with-others page on the webUI',
  async function(filename) {
    await client.page.sharedWithOthersPage().navigateAndWaitTillLoaded()
    const state = await client.page.FilesPageElement.filesList().isElementListed(filename)
    assert.ok(
      !state,
      `Error: Resource ${filename} is present on the shared-with-others page on the webUI`
    )
  }
)

Then(
  'file/folder {string} should be listed in shared-with-others page on the webUI',
  async function(filename) {
    await client.page.sharedWithOthersPage().navigateAndWaitTillLoaded()
    await client.page.FilesPageElement.filesList().waitForFileVisible(filename)

    return client
  }
)

Given('user {string} has created file {string}', function(userId, fileName) {
  return webdav.createFile(userId, fileName, '')
})

Given('user {string} has created the following folders', function(userId, entryList) {
  entryList.rows().forEach(entry => {
    webdav.createFolder(userId, entry[0])
  })
  return client
})
Given('user {string} has created the following files', function(userId, entryList) {
  entryList.rows().forEach(entry => {
    webdav.createFile(userId, entry[0])
  })
  return client
})

When('the user browses to the folder {string} on the files page', folderName => {
  const targetFolder = folderName === '/' ? '' : folderName
  return client.page.filesPage().navigateAndWaitTillLoaded(targetFolder)
})
When(
  'the user copies the permalink of the file/folder/resource {string} using the webUI',
  async function(file) {
    await client.page.FilesPageElement.appSideBar()
      .closeSidebar(100)
      .openPublicLinkDialog(file)
    await client.page.filesPage().copyPermalinkFromFilesAppBar()
    return client
  }
)
Then(
  'as user {string} the clipboard content should match permalink of resource {string}',
  async function(userId, folderName) {
    const folderData = await webdav.getProperties(folderName, userId, ['oc:privatelink'])
    return client.getClipBoardContent(function(value) {
      assert.strictEqual(folderData['oc:privatelink'], value)
    })
  }
)

Then('the app-sidebar for file/folder {string} should be visible on the webUI', async function(
  resource
) {
  const visible = await client.page.filesPage().isSidebarVisible()
  assert.strictEqual(visible, true, 'app-sidebar should be visible, but is not')
  return client.page.filesPage().checkSidebarItem(resource)
})

Then('the thumbnail should be visible in the app-sidebar', function() {
  return client.page.FilesPageElement.appSideBar().isThumbnailVisible()
})

When('the user deletes the file {string} from the deleted files list', function(element) {
  return client.page.FilesPageElement.filesList().deleteImmediately(element)
})

async function isPossibleToDeleteResourceOnWebUI(resource) {
  return !(await client.page.FilesPageElement.filesList().isActionAttributeDisabled(
    'delete',
    resource
  ))
}

Then('it should not be possible to delete file/folder {string} using the webUI', async function(
  resource
) {
  assert.strictEqual(
    await isPossibleToDeleteResourceOnWebUI(resource),
    false,
    `expected delete function of ${resource} to be disabled but it is enabled`
  )
})

Then('it should be possible to delete file/folder {string} using the webUI', async function(
  resource
) {
  assert.strictEqual(
    await isPossibleToDeleteResourceOnWebUI(resource),
    true,
    `expected delete function of ${resource} to be enabled but it is disabled`
  )
})

Then('it should not be possible to rename file/folder {string} using the webUI', async function(
  resource
) {
  const state = await client.page.FilesPageElement.filesList().isActionAttributeDisabled(
    'rename',
    resource
  )
  assert.ok(state, `expected property disabled of ${resource} to be 'true' but found ${state}`)
})

When('the user uploads overwriting file {string} using the webUI', function(file) {
  const uploadPath = path.join(client.globals.mountedUploadDir, file)
  return client.page
    .filesPage()
    .selectFileForUpload(uploadPath)
    .then(() => client.page.filesPage().confirmFileOverwrite())
})

When(
  'the user tries to create a file with already existing name {string} using the webUI',
  function(fileName) {
    return client.page.filesPage().triesToCreateExistingFile(fileName)
  }
)

Then('the create file button should be disabled', function() {
  return client.page.filesPage().checkForButtonDisabled()
})

When('user {string} has renamed the following file', function(user, table) {
  const fromName = table
    .hashes()
    .map(data => data['from-name-parts'])
    .join('')
  const toName = table
    .hashes()
    .map(data => data['to-name-parts'])
    .join('')
  return webdav.move(user, fromName, toName)
})

Then('the following file should not be listed on the webUI', async function(table) {
  const name = table
    .hashes()
    .map(data => data['name-parts'])
    .join('')
  const state = await client.page.FilesPageElement.filesList().isElementListed(name)
  return assert.ok(!state, `Element ${name} is present on the filesList!`)
})

Then('the user deletes the following file using the webUI', function(table) {
  const name = table
    .hashes()
    .map(data => data['name-parts'])
    .join('')
  return client.page.FilesPageElement.filesList().deleteFile(name)
})

Then('the user should be redirected to the files-drop page', function() {
  return client.page.filesDropPage().waitForPage()
})

Then('the user should be redirected to the public links page', function() {
  return client.page.publicLinkFilesPage().waitForPage()
})

Then('file/folder {string} shared by {string} should not be listed in the webUI', async function(
  element,
  sharer
) {
  const found = await client.page.sharedWithMePage().isSharePresent(element, sharer)
  assert.ok(
    !found,
    element + ' shared by ' + sharer + ' was present but was not expected to be present'
  )
})

Then('the page should be empty', async function() {
  const isVisible = await client.page.webPage().isPageVisible()
  assert.ok(!isVisible, 'The web page should be empty but is not')
})

When('the user downloads file/folder {string} using the webUI', function(file) {
  return client.page.FilesPageElement.filesList().downloadFile(file)
})

Then('the following resources should have share indicators on the webUI', async function(
  dataTable
) {
  for (const { fileName, expectedIndicators } of dataTable.hashes()) {
    const indicatorsArray = await client.page.FilesPageElement.filesList().getShareIndicatorsForResource(
      fileName
    )

    const expectedIndicatorsArray = expectedIndicators.split(',').map(s => s.trim())
    assert.ok(
      _.intersection(indicatorsArray, expectedIndicatorsArray).length ===
        expectedIndicatorsArray.length,
      `Expected share indicators to be the same for "${fileName}": expected [` +
        expectedIndicatorsArray.join(', ') +
        '] got [' +
        indicatorsArray.join(', ') +
        ']'
    )
  }
})

Then('the following resources should not have share indicators on the webUI', async function(
  dataTable
) {
  for (const [fileName] of dataTable.raw()) {
    const indicatorsArray = await client.page.FilesPageElement.filesList().getShareIndicatorsForResource(
      fileName
    )

    assert.ok(!indicatorsArray.length, `Expected no share indicators present for "${fileName}"`)
  }
})

async function _setFilesTableSort(column, isDesc) {
  await client.page.FilesPageElement.filesList().setSort(column, isDesc)
}

When('the user has set the sort order of the {string} column to descending order', async function(
  column
) {
  await _setFilesTableSort(column, true)
})
When('the user has set the sort order of the {string} column to ascending order', async function(
  column
) {
  await _setFilesTableSort(column, false)
})
Then('the file {string} should have a thumbnail displayed on the webUI', async function(resource) {
  const iconUrl = await client.page.FilesPageElement.filesList().getResourceThumbnail(
    resource,
    'file'
  )
  assert.ok(
    iconUrl && iconUrl.startsWith('blob:'),
    'Icon URL expected to be set when thumbnail is displayed'
  )
})
Then('the file {string} should have a file type icon displayed on the webUI', async function(
  resource
) {
  const iconUrl = await client.page.FilesPageElement.filesList().getResourceThumbnail(
    resource,
    'file'
  )
  assert.strictEqual(null, iconUrl, 'No icon URL expected when file type icon is displayed')
})

Then('quick action {string} should be displayed on the webUI', function(action) {
  return client.page.FilesPageElement.filesRow().isQuickActionVisible(action)
})

When('the user moves file/folder {string} into folder {string} using the webUI', function(
  resource,
  target
) {
  return client.page.FilesPageElement.filesList().moveResource(resource, target)
})

When('the user tries to move file/folder {string} into folder {string} using the webUI', function(
  resource,
  target
) {
  return client.page.FilesPageElement.filesList().attemptToMoveResource(resource, target)
})

When('the user cancels an attempt to move file/folder {string} using the webUI', function (
  resource
) {
  return client.page.FilesPageElement.filesList().cancelMoveResource(resource)
})

Then('it should not be possible to copy/move into folder {string} using the webUI', function(
  target
) {
  return client.page.FilesPageElement.filesList().navigationNotAllowed(target)
})

When(
  'the user batch moves these files/folders into folder {string} using the webUI',
  async function(target, resources) {
    for (const item of resources.rows()) {
      await client.page.FilesPageElement.filesList().toggleFileOrFolderCheckbox('enable', item[0])
    }

    return client.page.filesPage().moveMultipleResources(target)
  }
)

When('the user copies file/folder {string} into folder {string} using the webUI', function(
  resource,
  target
) {
  return client.page.FilesPageElement.filesList().copyResource(resource, target)
})

When('the user tries to copy file/folder {string} into folder {string} using the webUI', function(
  resource,
  target
) {
  return client.page.FilesPageElement.filesList().attemptToCopyResource(resource, target)
})

When(
  'the user batch copies these files/folders into folder {string} using the webUI',
  async function(target, resources) {
    for (const item of resources.rows()) {
      await client.page.FilesPageElement.filesList().toggleFileOrFolderCheckbox('enable', item[0])
    }

    return client.page.filesPage().copyMultipleResources(target)
  }
)

When('the user creates a markdown file with the name {string} using the webUI', function(fileName) {
  return client.page.filesPage().createMarkdownFile(fileName)
})

When('the user closes the text editor using the webUI', function() {
  return client.page.filesPage().closeTextEditor()
})

Then('the user should be in the root directory on the webUI', async function() {
  const isUserInRootDirectory = await client.page.filesPage().isRootDirectory()
  assert.ok(!isUserInRootDirectory, 'Expected user in the root directory but found elsewhere')
})

Then('the search bar should not be visible in the webUI', async function() {
  const isVisible = await client.page.filesPage().isSearchBarVisible()
  assert.strictEqual(isVisible, false, 'Expected search bar to be invisible but is visible')
})

Then('the search bar should be visible in the webUI', async function() {
  const isVisible = await client.page.filesPage().isSearchBarVisible()
  assert.strictEqual(isVisible, true, 'Expected search bar to be visible but is not visible')
})
