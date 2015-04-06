
class UpdateUserCtrl

    constructor: (@$log, @$location, @$routeParams, @UserService) ->
        @$log.debug "constructing UpdateUserController for #{@$routeParams.email}"
        @UserService.get(@$routeParams.email)
          .then(
            (data) =>
              @user = data
            (error) =>
              alert("User not found")
              @$log.error "can't get user #{@$routeParams.email}: #{error}"
              @$location.path("/")
        )

    updateUser: () ->
        @$log.debug "updateUser(#{@user.email})"
        @user.active = false
        @UserService.updateUser(@user)
        .then(
            (data) =>
                @$log.debug "Promise returned #{data} User"
                @user = data
                @$location.path("/")
            ,
            (error) =>
                @$log.error "Unable to update User: #{error}"
            )

controllersModule.controller('UpdateUserCtrl', UpdateUserCtrl)