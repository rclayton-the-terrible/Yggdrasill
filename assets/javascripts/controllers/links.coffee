###global define###

define ['c/controllers'], (controllers) ->
  'use strict'

  controllers.controller 'LinksController', ['$scope', ($scope) ->

    $scope.var1 = "Hello"
  ]