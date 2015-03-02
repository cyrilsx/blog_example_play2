class AddCommentCtrl
  constructor: (@$log, @$location, @CommentService) ->
    @$log.debug "constructing AddCommentCtrl"
    @comment = {}

  addComment: () ->
    @$log.debug "addComment()"
    @CommentService.create(@comment)
    .then(
      (data) =>
        @$log.debug "Promise returned #{data} Service"
        @user = data
        @$location.path("/")
    ,
      (error) =>
        @$log.error "Unable to create comment: #{error}"
    )


controllersModule.controller('AddCommentCtrl', AddCommentCtrl)
