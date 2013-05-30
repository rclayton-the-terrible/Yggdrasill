###global define###

define ['c/controllers'], (controllers) ->
  'use strict'

  controllers.controller 'OverviewController', ['$scope', ($scope) ->

      $scope.var1 = "Hello"
  ]