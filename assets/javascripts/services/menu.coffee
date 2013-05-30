class MenuService

  constructor: (@$rootScope, @$location, @menuChannel, @async) ->
    console.log "MenuService instantiated"

  items: [ ]

  handleRouteChange: (event, next, current) =>
    @refresh()

  setActive: (name) ->
    for item in @items
      if item.name is name
        item.active = true
      else
        item.active = false

  itemIsRegistered: (name) ->
    for item in @items
      if item.name is name
        return true
    false

  addItem: (menuItem) ->
    unless @itemIsRegistered menuItem.name
      menuItem.active = menuItem.active ? false
      menuItem.onClick = menuItem.onClick ? -> console.log "Clicked: #{menuItem.name}"
      menuItem.href = menuItem.href ? ""
      @items.push menuItem
      @$rootScope.$apply()

  refresh: =>
    url = "#" + @$location.url()
    for item in @items
      if item.href is url
        @async.until (=> not @$rootScope.$$phase), ((cb) -> setTimeout(cb, 10)), =>
          @$rootScope.$apply => @setActive(item.name)
        # Break early
        return true


define ["ang", "lodash", "async", "services/services", "services/pubsub"], (angular, _, async, services) ->

  console.log "Registering menuService"

  services.factory "menuService", [ "$rootScope", "$location", "menuChannel", ($rootScope, $location, menuChannel) ->

    console.log "Hello, in menuservice factory"

    menuService = new MenuService($rootScope, $location, menuChannel, async)

    $rootScope.$on "$routeChangeStart", menuService.handleRouteChange

    return menuService
  ]
