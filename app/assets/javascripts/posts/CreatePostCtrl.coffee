class CreatePostCtrl
  constructor: (@$log, @$location, @PostService) ->
    @$log.debug "constructing CreatePostCtrl"
    @post = {}
    @errors = []


  validateTitle: () ->
    @$log.debug "run title validation"
    if !@post.hasOwnProperty("title")
      @errors.push("Title is mandatory")
    else
      @errors.remove("Title is mandatory")


  validateContent: () ->
    @$log.debug "run content validation"
    if !@post.hasOwnProperty("content")
      @errors.push("Content is mandatory")
    else
      @errors.remove("Content is mandatory")


  validatePermalink: () ->
    @$log.debug "run permalink validation"
    if !@post.hasOwnProperty("permalink") || @post.permalink == ""
      @errors.push("Permalink is mandatory")
    else
      @errors.remove("Permalink is mandatory")


  validateActive: () ->
    @$log.debug "run active validation"
    if !@post.hasOwnProperty("active")
      @errors.push("Active is mandatory")
    else
      @errors.remove("Active is mandatory")



  createPost: () ->
    @$log.debug "createPost()"

    @PostService.create(@post)
    .then(
      (data) =>
        @$log.debug "Promise returned #{data} post"
        @post = data
        @$location.path("/")
    ,
      (error) =>
        @$log.error "Unable to create post: #{error}"
    )



controllersModule.controller('CreatePostCtrl', CreatePostCtrl)
