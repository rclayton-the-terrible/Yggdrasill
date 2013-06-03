# Prototype for Channel implementations
class Channel

  constructor: (@$rootScope, @async) ->
    console.log "Channel Started"

  # The complexity of this function should show you why you should be using it!
  on: (topic, handler) =>
    @$rootScope.$on topic, =>
      args = _.rest arguments
      # Until the rootScope is out of phase, wait.  When it's in phase,
      # excute the handler and refresh the scope context.
      @async.until (=> not @$rootScope.$$phase), ((cb) -> setTimeout(cb, 10)), =>
        @$rootScope.$apply -> handler.apply(null, args)

# For publishing events related to the selection of
# menu items.
class MenuChannel extends Channel

  menuItemClicked: (menuItemName) =>
    @$rootScope.$broadcast "menuItemClicked", menuItemName

  onMenuItemClicked: (handler) =>
    @on "menuItemClicked", handler



define ["ang", "lodash", "async", "services/services"], (angular, _, async, services)->

  console.log "Registering PubSub Channels"

  services.service "menuChannel", [
    "$rootScope", ($rootScope) -> new MenuChannel($rootScope, async)
  ]
