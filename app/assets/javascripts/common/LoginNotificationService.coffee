class LoginNotificationService

  constructor: (@$log, @$rootScope) ->
    @$log.debug "constructor LoginNotificationService"

  subscribe: (scope, callback) ->
    handler = @$rootScope.$on('notification-service-event', callback)
    scope.$on('$destroy', handler)

  notify: () ->
    @$rootScope.$emit('notification-service-event')

servicesModule.service('LoginNotificationService', LoginNotificationService)
