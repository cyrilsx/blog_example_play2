class LoginCtrl

    constructor: (@$log, @$rootScope, @$scope, @$location,  @UserService) ->
        @$log.debug "constructing LoginCtrl"
        @loginForm = {}

    login: () ->
        @$log.debug "login(#{@loginForm.email})"
        @UserService.login(@loginForm)
        .then(
            (data) =>
                @$log.debug "Promise returned #{data} User"
                @$location.path("/")
                #@$scope.$apply()
            ,
            (error) =>
                @$log.error "Unable to create User: #{error}"
            )

    logout: () ->
      @$log.debug "login(#{@loginForm.email})"
      @UserService.logout()
      @$location.path("/")



controllersModule.controller('LoginCtrl', LoginCtrl)