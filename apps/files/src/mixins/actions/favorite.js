import { mapActions } from 'vuex'

import { checkRoute } from '../../helpers/route'

export default {
  computed: {
    $_favorite_items() {
      return [
        {
          icon: 'star',
          handler: this.$_favorite_trigger,
          ariaLabel: item => {
            if (item.starred) {
              return this.$gettext('Unmark as favorite')
            }
            return this.$gettext('Mark as favorite')
          },
          isEnabled: () => {
            const isRouteAllowed = checkRoute(['files-list', 'files-favorites'], this.$route.name)

            return (
              this.isAuthenticated &&
              this.capabilities.files &&
              this.capabilities.files.favorites &&
              isRouteAllowed
            )
          }
        }
      ]
    }
  },
  methods: {
    ...mapActions('Files', ['markFavorite']),

    $_favorite_trigger(resource) {
      this.markFavorite({
        client: this.$client,
        file: resource
      }).catch(() => {
        const translated = this.$gettext('Error while starring "%{file}"')
        const title = this.$gettextInterpolate(translated, { file: resource.name }, true)
        this.showMessage({
          title: title,
          status: 'danger',
          autoClose: {
            enabled: true
          }
        })
      })
    }
  }
}
