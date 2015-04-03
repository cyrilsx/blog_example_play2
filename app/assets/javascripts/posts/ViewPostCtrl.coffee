class ViewPostCtrl
  constructor: (@$routeParams, @$log, @$location, @PostService) ->
    @$log.debug "constructing ViewPostCtrl #{@$routeParams.postId}"
    @post ={}
    @PostService.getById(@$routeParams.postId)
    .then(
      (data) =>
        @post = data
    ,
      (error) =>
        @$log.debug "can't display post: #{error}"
    )


  delete: (permalink) ->
    @PostService.delete(permalink)
    .then(
      (data) =>
        @$log.debug "Post #{permalink} deleted"
        @$location.path("#/")
    ,
      (error) =>
        @$log.debug "Can't delete post #{permalink} deleted"
    )

controllersModule.controller('ViewPostCtrl', ViewPostCtrl)