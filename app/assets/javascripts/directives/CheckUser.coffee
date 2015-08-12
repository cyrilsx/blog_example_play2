directivesModule.directive('userNavigation', ->
  templateUrl: '/assets/partials/directives/user_navigation.html',
  transclude: true,
  restrict: 'E',
  controller: (@$scope, LoginNotificationService, UserService) ->
    @refreshMenu = ->
      console.log("Receive event @UserService.user")

    LoginNotificationService.subscribe(@$scope, @refreshMenu)
)

