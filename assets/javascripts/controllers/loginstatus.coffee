###global define###

define ['c/controllers', 'lodash'], (controllers, _) ->
  'use strict'

  controllers.controller 'LoginStatusController', ['$rootScope', '$scope', ($rootScope, $scope) ->

    dpd.users.me (user) ->
      if user? and not _.isEmpty user
        $scope.$apply ->
          $rootScope.$broadcast "user#loggedIn", user

    $rootScope.isLoggedIn = false

    $rootScope.$on "user#loggedIn", (event, user) ->
      $rootScope.isLoggedIn = true
      $scope.username = user.username
      $scope.displayName = user.displayName

    $rootScope.$on "user#loggedOut", (event) ->
      $rootScope.isLoggedIn = false
      $scope.username = null
      $scope.displayName = null
  ]