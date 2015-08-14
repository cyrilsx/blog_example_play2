directivesModule.directive('userNavigation', ->
  templateUrl: '/assets/partials/directives/user_navigation.html',
  transclude: true,
  menu: '='
  restrict: 'E',
  controller: ($scope, LoginNotificationService, UserService) ->
    $scope.menu = {}

    @logout = ->
      UserService.logout()
      @refreshMenu()

    @refreshMenu = ->
      console.log("Receive event #{UserService.user}")
      if not UserService.logged
        $scope.menu = [
#          {
#            title: "Create Post",
#            url: "#/post/create"
#          },
          {
            title: "Sign In",
            url: "#/user/login"
          }
        ]
      else
        $scope.menu = [
          {
            title: "Create Post",
            url: "#/post/create"
          },
          {
            title: "Logout #{UserService.user.displayName}",
            url: "#",
            action: "logout()"
          },
        ]
    @refreshMenu()
    LoginNotificationService.subscribe($scope, @refreshMenu)
)

