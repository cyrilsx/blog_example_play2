class ListPostCtrl
  constructor: (@$log, @$location, @PostService) ->
    @$log.debug "constructing ListPostCtrl"
    @nbElemPage = 10
    @posts = []
    @listAll()

  listAll: () ->
    @$log.debug "listAll()"

    @PostService.listAll(0, @nbElemPage)
    .then(
      (data) =>
        @$log.debug "Promise returned #{data.length} post"
        @posts = data
    ,
      (error) =>
        @$log.error "Unable to get Application: #{error}"
    )


controllersModule.controller('ListPostCtrl', ListPostCtrl)