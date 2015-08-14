directivesModule.directive('userNavigation', ->
  templateUrl: '/assets/partials/directives/user_navigation.html',
  transclude: true,
  menu: '='
  restrict: 'E',
  controller: ($scope, LoginNotificationService, UserService) ->

    $scope.logout = ->
      UserService.logout()
      @refreshMenu()

    @refreshMenu = ->
      console.log("Receive event #{UserService.user}")
      if UserService.logged
        $scope.loginBtn=undefined
        $scope.logoutBtn=true
        $scope.createPostBtn=true
      else
        $scope.loginBtn=true
        $scope.logoutBtn=undefined
        $scope.createPostBtn=undefined
    @refreshMenu()
    LoginNotificationService.subscribe($scope, @refreshMenu)
)

