

class GraphService

  constructor: (@async) ->
    console.log "GraphService instantiated."

  walk: (centerId, depth, streamingCallback, finalCallback) =>
    dpd.links.get @buildQuery(centerId), (links) =>
      streamingCallback links
      context = @buildContext context
      @enhanceContext context, links
      @subsequentWalk context, --depth, streamingCallback, finalCallback

  subsequentWalk: (context, depth, streamingCallback, finalCallback) =>
    unless depth is 0
      targets = @findUnvisitedNodes context
      buckets = @makeBuckets targets
      tasks = []
      buckets.forEach (bucket) =>
        tasks.push (cb) =>
          dpd.links.get @buildQuery(bucket), (links) =>
            streamingCallback links
            cb null, links
      links = []
      @async.parallel tasks, (err, results) =>
        links = _.flatten results
      @enhanceContext context, links
      @subsequentWalk context, --depth, streamingCallback, finalCallback
    else
      finalCallback() if finalCallback()

  findUnvisitedNodes: (context) =>
    targets = []
    for k, person of context.people
      unless _.has person, "__visited"
        targets.push person.id
        person.__visited = true
    targets

  makeBuckets: (a) =>
    bucket = []
    inc = 0
    for i in [0..a.length]
      if i % 10 is 0
        inc++
        bucket[inc] = []
      bucket[inc].push a[i]
    bucket


  enhanceContext: (context, links) =>
    links.forEach (link) =>
      unless _.has context.links, link.id
        context.links[link.id] = link
        link.people.forEach (person) =>
          unless _.has context.people, person.id
            context.people[person.id] = person

  buildQuery: (nodes) =>
    nodes = [ nodes ] unless nodes.push?
    query =
      people:
        $in: nodes
      include: "people"

  buildContext: (context) =>
    context =
        links: {}
        people: {}



define ["services/services", "lodash", "async"], (services, _, async)->

  console.log "Registering Graph Service"

  services.service "graphService", [ -> new GraphService(async) ]
