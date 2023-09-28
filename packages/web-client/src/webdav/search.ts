import { unref } from 'vue'
import { Resource, buildResource } from '../helpers'
import { WebDavOptions } from './types'
import { DavProperties, DavProperty, DavPropertyValue } from './constants'

export interface SearchResource extends Resource {
  highlights: string
}

export type SearchOptions = {
  davProperties?: DavPropertyValue[]
  searchLimit?: number
}

export type SearchResult = {
  resources: SearchResource[]
  totalResults: number
}

export const SearchFactory = ({ sdk, capabilities }: WebDavOptions) => {
  return {
    async search(
      term: string,
      { davProperties = DavProperties.Default, searchLimit }: SearchOptions
    ): Promise<SearchResult> {
      const useSpacesEndpoint = unref(capabilities)?.spaces?.enabled === true
      const { range, results } = await sdk.files.search(
        term,
        searchLimit,
        davProperties,
        useSpacesEndpoint
      )

      return {
        resources: results.map((r) => ({
          ...buildResource(r),
          highlights: r.fileInfo[DavProperty.Highlights] || ''
        })),
        totalResults: range ? parseInt(range?.split('/')[1]) : null
      }
    }
  }
}
