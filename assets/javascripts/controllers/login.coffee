###global define###

define ['c/controllers'], (controllers) ->
  'use strict'

  controllers.controller 'LoginController', ['$rootScope', '$scope', '$location', ($rootScope, $scope, $location) ->

    goto = (path) ->
      $scope.$apply ->
        $location.path path

    $scope.login = ->
      $scope.error = null
      ctx = { username: $scope.username, password: $scope.password }
      dpd.users.login ctx, ->

        if arguments.length is 2
          err = arguments[0]
          response = arguments[1]
        else
          token = arguments[0]

        if token?
          dpd.users.me (user) ->
            $rootScope.$broadcast "user#loggedIn", user
            goto "/overview"

        else
          if response.status? and response.status is 401
            $scope.error = "Username or password may be incorrect."
          else
            message = err ? response.message
            $scope.error = "Problem logging into the server: #{message}"
          $scope.$apply()


    $scope.request = ->
      goto "/request"



  ]