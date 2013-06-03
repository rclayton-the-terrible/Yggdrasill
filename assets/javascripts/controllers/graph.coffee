###global define###

define ['c/controllers', 'lodash'], (controllers, _) ->
  'use strict'

  controllers.controller 'GraphController', ['$scope', '$rootScope', 'graphService', ($scope, $rootScope, graph) ->

      layout = (layoutType) ->
        $rootScope.$broadcast "cytoscape#layout", { target: "*", layout: layoutType }

      $scope.performLayout = (layoutType) -> layout(layoutType)

      $scope.clearGraph = ->
        $rootScope.$broadcast "cytoscape#clear"

      query =
        name:
          $regex: "Bashar Al-Assad"
          $options: "i"

      hasNode = (nodeId, peopleArray) ->
        result = false
        for person in peopleArray
          return true if person.id is nodeId
        result

      broadcastResults = (links) ->

        nodes = []

        links.forEach (link) ->
          unless _.has nodes, link.source
            nodes.push { id: link.source, name: link.sourceName }
          unless _.has nodes, link.target
            nodes.push { id: link.target, name: link.targetName }

        $rootScope.$broadcast "cytoscape#addElements", { edges: links, nodes: _.values(nodes) }

      dpd.people.get query, (people) ->
        graph.walk people[0].id, 1, broadcastResults, layout


      $rootScope.$on "cytoscape#nodeClicked", (event, node) ->
        graph.walk node.id, 1, broadcastResults, layout

  ]
