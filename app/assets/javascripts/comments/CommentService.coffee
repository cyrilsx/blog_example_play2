class CommentService

  @headers = {'Accept': 'application/json', 'Content-Type': 'application/json'}
  @defaultConfig = { headers: @headers }

  constructor: (@$log, @$http, @$q) ->
    @$log.debug "constructing CommentService"

  listAll: (postId) ->
    @$log.debug "list all comments"
    deferred = @$q.defer()

    @$http.get("/comments/" + postId)
    .success((data, status, headers) =>
      @$log.info("Successfully listed services - status #{status}")
      deferred.resolve(data)
    )
    .error((data, status, headers) =>
      @$log.error("Failed to list Services - status #{status}")
      deferred.reject(data);
    )
    deferred.promise

  create: (comment) ->
    @$log.debug "create a comment"
    @saveOrUpdate('/comment', comment, @$http.post)

  update: (comment) ->
    @$log.debug "update a comment"
    @saveOrUpdate('/comment', comment, @$http.put)

  saveOrUpdate: (url, server, func) ->
    deferred = @$q.defer()

    func(url, server)
    .success((data, status, headers) =>
      @$log.info("Successfully created Server - status #{status}")
      deferred.resolve(data)
    )
    .error((data, status, headers) =>
      @$log.error("Failed to create server - status #{status}")
      deferred.reject(data);
    )
    deferred.promise


servicesModule.service('CommentService', CommentService)
