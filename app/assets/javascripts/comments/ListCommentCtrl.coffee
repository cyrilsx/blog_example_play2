class ListCommentCtrl
  constructor: (@$log, @$location, @ServerService) ->
    @$log.debug "constructing ServerCtrl"
    @servers = []
    @listAll()

  listAll: () ->
    @$log.debug "findComments()"

    @CommentService.listAll()
    .then(
      (data) =>
        @$log.debug "Promise returned #{data.length} Comments"
        @users = data
    ,
      (error) =>
        @$log.error "Unable to get Comments: #{error}"
    )


controllersModule.controller('ListCommentCtrl', ListCommentCtrl)