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


app.config ($httpProvider) ->
  $httpProvider.interceptors.push(['$q', '$location', ($q, $location) ->
    request: (config) -> config
    requestError: (rejection) -> rejection
    response: (response) -> response

    responseError: (response) ->
      if response.status == 401
        $location.path('#/user/login/')
        return $q.reject(response)
      else
        return $q.reject(response)
  ])

  $httpProvider.defaults.withCredentials = true

angular.module('myApp.routeConfig', ['ngRoute'])
.config ($routeProvider) ->
  $routeProvider
  .when('/', {
      templateUrl: '/assets/partials/post/list.html'
    })
  .when('/post/create', {
      templateUrl: '/assets/partials/post/edit.html'
    })
  .when('/post/update/:postId', {
      templateUrl: '/assets/partials/post/edit.html'
    })
  .when('/post/view/:postId', {
      templateUrl: '/assets/partials/post/list.html'
    })
  .when('/user/create', {
      templateUrl: '/assets/partials/user/create.html'
    })
  .when('/user/update/:email', {
      templateUrl: '/assets/partials/user/edit.html'
    })
  .when('/users/', {
      templateUrl: '/assets/partials/user/list.html'
    })
  .when('/user/login/', {
      templateUrl: '/assets/partials/user/login.html'
    })
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
