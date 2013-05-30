###global define###

define ['c/controllers'], (controllers) ->
  'use strict'

  controllers.controller 'SourcesController', ['$scope', ($scope) ->

    $scope.var1 = "Hello"
  ]