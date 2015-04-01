dependencies = [
  'ngRoute',
  'ui.bootstrap',
  'myApp.filters',
  'myApp.services',
  'myApp.controllers',
  'myApp.directives',
  'myApp.common',
  'myApp.routeConfig'
]

app = angular.module('myApp', dependencies)

angular.module('myApp.routeConfig', ['ngRoute'])
.config ($routeProvider) ->
  $routeProvider
  .when('/', {
      templateUrl: '/assets/partials/post.html'
    })
  .when('/post/create', {
      templateUrl: '/assets/partials/create_post.html'
    })
  .when('/post/update/:postId', {
      templateUrl: '/assets/partials/create_post.html'
    })
#  .when('/users/create', {
#      templateUrl: '/assets/partials/create.html'
#    })
#  .when('/apps', {
#      templateUrl: '/assets/partials/post.html'
#    })
#  .when('/apps/create', {
#      templateUrl: '/assets/partials/create_apps.html'
#    })
#  .when('/servers', {
#      templateUrl: '/assets/partials/servers.html'
#    })
#  .when('/servers/create', {
#      templateUrl: '/assets/partials/create_server.html'
#    })
  .otherwise({redirectTo: '/'})

@commonModule = angular.module('myApp.common', [])
@controllersModule = angular.module('myApp.controllers', [])
@servicesModule = angular.module('myApp.services', [])
@modelsModule = angular.module('myApp.models', [])
@directivesModule = angular.module('myApp.directives', [])
@filtersModule = angular.module('myApp.filters', [])