###global define###

define ['c/controllers'], (controllers) ->
  'use strict'

  controllers.controller 'CommentsController', ['$scope', ($scope) ->

    $scope.var1 = "Hello"
  ]