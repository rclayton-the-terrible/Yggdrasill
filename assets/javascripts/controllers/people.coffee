###global define###

define ['lodash', 'c/controllers'], (_, controllers) ->
  'use strict'

  controllers.controller 'PeopleController', ['$scope', ($scope) ->

    $scope.focusedView = "overview-people"

    getPeople = (query) =>
      query = query ? {}
      dpd.people.get query, (data) =>
        $scope.people = _.values data
        $scope.$apply()

    getPeople()

    limit = 25

    $scope.page = 1

    $scope.search = =>
      query = { $limit: limit, $skip: ($scope.page - 1) * limit}
      getPeople query




  ]