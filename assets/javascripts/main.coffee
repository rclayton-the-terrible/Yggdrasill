#using requirejs config + require

requirejs.config
  #urlArgs: "bust=" +  (new Date()).getTime()
  map:
    '*':
      'vendor/angularResource': 'vendor/angular-resource'
  paths:
    c:"controllers"
    d:"directives"
    l18n:"vendor/l18n"
    jquery:"vendor/jquery"
    ang:"vendor/angular.min.1.1.4"
    twboot:"vendor/bootstrap"
    lodash: "vendor/lodash"
    async: "vendor/async"
    smscroll: "vendor/jquery.smooth-scroll.min"
    cytoscape: "vendor/cytoscape"
  shim:
    'ang':
      deps: ['vendor/modernizr']
      exports: 'angular'
    'vendor/angular-resource': ['ang']
    'vendor/modernizr':
      exports: 'Modernizr'
    'smscroll': ['jquery']
    'cytoscape': ['jquery', 'vendor/arbor']

requirejs ['app'
    'l18n!nls/hello'
    'jquery'
    'templates'
    'twboot'
    'bootstrap'
    'c/people'
    'c/overview'
    'c/comments'
    'c/export'
    'c/links'
    'c/media'
    'c/sources'
    'c/graph'
    'c/login'
    'c/logout'
    'c/loginstatus'
    'd/ngController'
    'd/cytoscape'
    'services/graph'
    'filters/twitterfy'
    'ang'
    'responseInterceptors/dispatcher'
], (app, hello, $, templates) ->

    #$('body').append('Localized hello ==> ' + hello.hello)

    rp = ($routeProvider) ->
      $routeProvider
        .when '/overview',
          controller: 'OverviewController'
          templateUrl: 'layout-overview'
          reloadOnSearch: true
          #resolve:
            #changeTab: ($rootScope) ->
            #  $rootScope.$broadcast 'changeTab#gitHub'

        .when '/comments',
          controller: 'CommentsController'
          templateUrl: 'layout-comments'
          reloadOnSearch: true

        .when '/export',
          controller: 'ExportController'
          templateUrl: 'layout-export'
          reloadOnSearch: true

        .when '/links',
          controller: 'LinksController'
          templateUrl: 'layout-links'
          reloadOnSearch: true

        .when '/media',
          controller: 'MediaController'
          templateUrl: 'layout-media'
          reloadOnSearch: true

        .when '/people',
          controller: 'PeopleController'
          templateUrl: 'layout-people'
          reloadOnSearch: true

        .when '/people/:personid',
          controller: 'PeopleController'
          templateUrl: 'layout-people'
          reloadOnSearch: true

        .when '/sources',
          controller: 'SourcesController'
          templateUrl: 'layout-sources'
          reloadOnSearch: true

        .when '/graph',
          controller: 'GraphController'
          templateUrl: 'layout-graph'
          reloadOnSearch: true

        .when '/login',
          controller: 'LoginController'
          templateUrl: 'layout-login'
          reloadOnSearch: true

        .when '/logout',
          controller: 'LogoutController'
          templateUrl: 'layout-logout'
          reloadOnSearch: true

        .otherwise
          redirectTo: '/overview'

    app.config ['$routeProvider', rp]

    app.run ['$rootScope', '$log', ($rootScope, $log) ->
      $rootScope.$on 'error:unauthorized', (event, response) ->
        #$log.error 'unauthorized'

      $rootScope.$on 'error:forbidden', (event, response) ->
        #$log.error 'forbidden'

      $rootScope.$on 'error:403', (event, response) ->
        #$log.error '403'

      $rootScope.$on 'success:ok', (event, response) ->
        #$log.info 'success'

      # fire an event related to the current route
      $rootScope.$on '$routeChangeSuccess', (event, currentRoute, priorRoute) ->
        $rootScope.$broadcast "#{currentRoute.controller}$routeChangeSuccess", currentRoute, priorRoute
    ]

    app.run ["$templateCache", ($templateCache)->
      for name, template of templates
        $templateCache.put name, template
    ]