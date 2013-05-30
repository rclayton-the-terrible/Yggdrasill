define ["c/controllers", "services/menu"], (controllers) ->

  console.log "Loading MenuController"

  controllers.controller "MenuController", ["$scope", "menuService", ($scope, menuService)->

    console.log "Registering MenuController"

    $scope.menuItems = []

  ]