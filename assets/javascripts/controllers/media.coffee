###global define###

define ['c/controllers'], (controllers) ->
  'use strict'

  controllers.controller 'MediaController', ['$scope', ($scope) ->

    $scope.var1 = "Hello"
  ]