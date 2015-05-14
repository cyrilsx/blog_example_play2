class LoginCtrl

    constructor: (@$log, @$rootScope, @$location,  @UserService) ->
        @$log.debug "constructing LoginCtrl"
        @loginForm = {}

    login: () ->
        @$log.debug "login(#{@loginForm.email})"
        @UserService.login(@loginForm)
        .then(
            (data) =>
                @$log.debug "Promise returned #{data} User"
                @$rootScope.user = data
                @$location.path("/")
            ,
            (error) =>
                @$log.error "Unable to create User: #{error}"
            )

    logout: () ->
      @$log.debug "login(#{@loginForm.email})"
      @UserService.logout()
      @$rootScope.$broadcast("userLoggedOut")
      @$location.path("/")



controllersModule.controller('LoginCtrl', LoginCtrl)