define ["ang","jquery", "lodash", "d/directives", "cytoscape"], (angular, $, _, directives) ->

  console.log cytoscape

  directives.directive "cytoscape", [ "$rootScope", ($rootScope) ->

    class Cytoscape

      restrict: "E"

      selectedLayout: "arbor"

      styleConf: cytoscape.stylesheet()
        .selector('node').css({
          'content': 'data(name)',
          'text-valign': 'center',
          'color': 'white',
          'text-outline-width': 2,
          'text-outline-color': '#888'
        })
        .selector('edge').css({
          'target-arrow-shape': 'triangle'
        })
        .selector(':selected').css({
          'background-color': 'black',
          'line-color': 'black',
          'target-arrow-color': 'black',
          'source-arrow-color': 'black'
        })
        .selector('.faded').css({
          'opacity': 0.25,
          'text-opacity': 0
        })

      knownEdges: {}
      knownNodes: {}

      constructor: (@$rootScope) ->
        console.log "Cytoscape initialized"

      onReady: (event) =>
        # Cytoscape instance
        @cy = event.cy

        @cy.elements().unselectify()

        @cy.on "tap", "node", @onNodeClicked
        @cy.on "tap", "edge", @onEdgeClicked

        @cy.on "tap", (e) =>
          if e.cyTarget is @cy
            @cy.elements().removeClass "faded"

      link: (scope, element, attrs) =>

        @name = attrs.name ? ("cyto_" + new Date().getTime())

        height = attrs.height ? "500px"
        width = attrs.width ? "500px"
        minHeight = attrs.minHeight ? "500px"
        minWidth = attrs.minWidth ? "500px"

        elem =  "<div id='#{@name}' style='width: #{width}; min-width: #{minWidth},"
        elem += " height: #{height}; min-height: #{minHeight};'></div>"

        $(element[0]).append(elem)

        $canvas = $("##{@name}")

        $($canvas).cytoscape options =
          style: @styleConf
          #elements: @elements
          ready: @onReady
          layout:
            name: @selectedLayout

        @cy = $($canvas).cytoscape("get")
        window.cy = @cy

        # Layout requests
        @$rootScope.$on "cytoscape#layout",      @onLayoutRequest
        @$rootScope.$on "cytoscape#addNodes",    @onAddNodesRequest
        @$rootScope.$on "cytoscape#addEdges",    @onAddEdgesRequest
        @$rootScope.$on "cytoscape#addElements", @onAddElementsRequest
        @$rootScope.$on "cytoscape#clear",       @onClearElementsRequest

      isMe: (context) =>
        ctx = ctx ? {}
        ctx.target = ctx.target ? "*"
        if ctx.target is @name or ctx.target is "*"
          true
        else
          false


      onNodeClicked: (e) =>
        node = e.cyTarget
        neighborhood = node.neighborhood().add node
        @cy.elements().addClass "faded"
        neighborhood.removeClass "faded"
        @$rootScope.$broadcast "cytoscape#nodeClicked", node.data()


      onEdgeClicked: (e) =>
        edge = e.cyTarget
        @$rootScope.$broadcast "cytoscape#edgeClicked", edge.data()

      onLayoutRequest: (event, ctx) =>
        if @isMe(ctx)
          @selectedLayout = ctx.layout if ctx.layout?
          @layout()

      onAddNodesRequest: (event, ctx) =>
        if @isMe(ctx)
          nodes = ctx.nodes
          nodes = [ nodes ] unless nodes.push?
          nodes.forEach (node) =>
            n =
              group: "nodes"
              data: node
            @cy.add(n)

      onAddEdgesRequest: (event, ctx) =>
        if @isMe(ctx)
          edges = ctx.edges
          edges = [ edges ] unless edges.push?
          edges.forEach (edge) =>
            e =
              group: "edges"
              data: edge
            @cy.add(e)

      onAddElementsRequest: (event, context) =>
        if @isMe(context)
          elements =
            nodes: []
            edges: []

          context.nodes.forEach (node) =>
            unless _.has @knownNodes, node.id
              elements.nodes.push n =
                group: "nodes"
                data: node
              @knownNodes[node.id] = true

          context.edges.forEach (edge) =>

            unless _.has @knownEdges, edge.id
              elements.edges.push e =
                group: "edges"
                data:
                  id: edge.id
                  source: edge.source
                  target: edge.target
                  ctx: edge
              @knownEdges[edge.id] = true

          @cy.add elements


      onClearElementsRequest: (event, context) =>
         if @isMe(context)
           @cy.remove ""


      layout: =>
        @cy.layout { name: @selectedLayout }



    return new Cytoscape($rootScope)
  ]





