###global define###

define ['c/controllers'], (controllers) ->
  'use strict'

  controllers.controller 'LogoutController', ['$rootScope', '$scope', '$location', ($rootScope, $scope, $location) ->

    goto = (path) ->
      $scope.$apply ->
        $location.path path

    $scope.logout = ->
      $scope.error = null
      dpd.users.logout (result, err) ->
        if err?
          $scope.error = err
        else
          $rootScope.$broadcast "user#loggedOut", null
          goto "/overview"

    $scope.back = ->
      history.back()

  ]