###global define###

define ['c/controllers'], (controllers) ->
  'use strict'

  controllers.controller 'ExportController', ['$scope', ($scope) ->

    $scope.var1 = "Hello"
  ]