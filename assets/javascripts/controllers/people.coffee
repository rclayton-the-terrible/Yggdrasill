###global define###

define ['lodash', "jquery", 'c/controllers'], (_, $, controllers) ->
  'use strict'

  controllers.controller 'PeopleController', ['$rootScope', '$scope', '$routeParams', ($rootScope, $scope, $routeParams) ->

    limit = 15
    page = 1

    $scope.hasNext = true
    $scope.hasPrevious = false

    $scope.focusedView = "overview-people"

    getPeople = (query) =>
      query = query ? { $limit: limit, $skip: 0 }
      dpd.people.get query, (data) =>
        $scope.people = _.values data
        if data.length < limit
          $scope.hasNext = false
        else if page is 1
          $scope.hasPrevious = false
        else
          $scope.hasNext = true
          $scope.hasPrevious = true
        $scope.$apply()

    getPeople()

    $scope.next = =>
      page++
      query = { $limit: limit, $skip: (page - 1) * limit}
      getPeople(query)

    $scope.previous = =>
      page--
      query = { $limit: limit, $skip: (page - 1) * limit}
      getPeople(query)

    $scope.search = =>
      query = { $limit: limit, $skip: (page - 1) * limit}
      getPeople query

    $scope.select = (id) =>
      $scope.focusedView = "view-person"
      dpd.people.get id, (person, err) =>
        if person?
          $rootScope.$broadcast "person#selected", person

    if $routeParams.personid?
      $scope.select $routeParams.personid

  ]

  controllers.controller 'PersonController', ['$rootScope', '$scope', ($rootScope, $scope) ->

    $scope.person = null

    $rootScope.$on "person#selected", (event, person) ->
      $scope.$apply ->
        $scope.person = person



  ]