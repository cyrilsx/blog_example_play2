class ListPostCtrl
  constructor: (@$log, @$location, @PostService) ->
    @$log.debug "constructing ListPostCtrl"
    @nbElemPage = 10
    @post = {}
    @listAll()

  getPost: () ->
    @$log.debug "getPost()"

    @PostService.(0, @nbElemPage)
    .then(
      (data) =>
        @$log.debug "Promise returned #{data.length} post"
        @posts = data
    ,
      (error) =>
        @$log.error "Unable to get Application: #{error}"
    )


  delete: (permalink) ->
     @PostService.delete(permalink)


controllersModule.controller('ListPostCtrl', ListPostCtrl)