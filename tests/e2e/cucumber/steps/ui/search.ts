import { When, Then } from '@cucumber/cucumber'
import { World } from '../../environment'
import { objects } from '../../../support'
import { expect } from '@playwright/test'

When(
  '{string} searches {string} using the global search bar',
  async function (this: World, stepUser: string, keyword: string): Promise<void> {
    const { page } = this.actorsEnvironment.getActor({ key: stepUser })
    const searchObject = new objects.applicationFiles.Search({ page })
    await searchObject.fullTextSearch({ keyword })
  }
)

Then(
  '{string} should see the message {string} on the webUI',
  async function (this: World, stepUser: string, message: string): Promise<void> {
    const { page } = this.actorsEnvironment.getActor({ key: stepUser })
    const searchObject = new objects.applicationFiles.Search({ page })
    const actualMessage = await searchObject.getSearchResultMessage()
    expect(actualMessage).toBe(message)
  }
)

When(
  '{string} selects tag {string} from the search result filter chip',
  async function (this: World, stepUser: string, tag: string): Promise<void> {
    const { page } = this.actorsEnvironment.getActor({ key: stepUser })
    const searchObject = new objects.applicationFiles.Search({ page })
    await searchObject.selectTagFilter({ tag })
  }
)

When('{string} clears tag filter', async function (this: World, stepUser: string): Promise<void> {
  const { page } = this.actorsEnvironment.getActor({ key: stepUser })
  const searchObject = new objects.applicationFiles.Search({ page })
  await searchObject.clearTagFilter()
})

When(
  /^"([^"]*)" (enable|disable)s the option to search in file content?$/,
  async function (this: World, stepUser: string, enableOrDisable: string): Promise<void> {
    const { page } = this.actorsEnvironment.getActor({ key: stepUser })
    const searchObject = new objects.applicationFiles.Search({ page })
    await searchObject.toggleSearchInFileContent({ enableOrDisable })
  }
)