class NavCtrl

  constructor: (@$log, @$scope, @$location, @UserService) ->
    @$log.debug "constructing NavCtrl"
    @menu = {}
    @UserService.$watch("user", @refreshMenu(), true)
    @refreshMenu()

  refreshMenu: () ->
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