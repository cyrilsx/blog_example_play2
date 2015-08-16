directivesModule.directive('navigationBar', ->
  templateUrl: '/assets/partials/directives/navigation_bar.html',
  transclude: true,
  restrict: 'E',
  controller: ($scope, LoginNotificationService, UserService) ->

    $scope.user = {}

    @refreshMenu = ->
      console.log("Receive event #{UserService.user}")
      $scope.user = UserService.user
    @refreshMenu()
    LoginNotificationService.subscribe($scope, @refreshMenu)
)

