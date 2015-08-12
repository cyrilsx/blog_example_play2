class NavCtrl

  constructor: (@$log, @$scope, @$location, @LoginNotificationService, @UserService) ->
    @$log.debug "constructing NavCtrl"
    @menu = {}
    @LoginNotificationService.subscribe(@$scope, @refreshMenu)
    @refreshMenu()

  refreshMenu: () ->
    #  NavCtrl.$inject = ['log', 'scope', 'location', 'LoginNotificationService', 'UserService']

    if(@UserService.logged)
      @$log.debug "user is logged"
      @buildLoggedMenu(@UserService.user)
    else
      @$log.debug "user is anonymous"
      @buildAnonymousMenu()


  buildAnonymousMenu: () ->
    @menu = [
      {
        title: "Create Post",
        url: "#/post/create"
      },
      {
        title: "Sign In",
        url: "#/user/login"
      }
    ]

  buildLoggedMenu: (user) ->
    @menu = [
      {
        title: "Create Post",
        url: "#/post/create"
      },
      {
        title: "Logout #{user.displayName}",
        url: "#/user/login"
      },
    ]

controllersModule.controller('NavCtrl', NavCtrl)