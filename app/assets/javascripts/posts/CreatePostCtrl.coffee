class CreatePostCtrl
  constructor: (@$log, @$location, @ApplicationService) ->
    @$log.debug "constructing CreatePostCtrl"
    @application = {}

  createApplication: () ->
    @$log.debug "createApplication()"
    @PostService.create(@application)
    .then(
      (data) =>
        @$log.debug "Promise returned #{data} Application"
        @user = data
        @$location.path("/")
    ,
      (error) =>
        @$log.error "Unable to create Application: #{error}"
    )



controllersModule.controller('CreatePostCtrl', CreatePostCtrl)
