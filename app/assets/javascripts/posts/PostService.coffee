class PostService

  @headers = {'Accept': 'application/json', 'Content-Type': 'application/json'}
  @defaultConfig = {headers: @headers}

  constructor: (@$log, @$http, @$q) ->
    @$log.debug "constructing PostService"

  listAll: (from, to) ->
    @$log.debug "list all post"
    deferred = @$q.defer()

    @$http.get("/posts/" + from + "/to/" + to)
    .success((data, status, headers) =>
      @$log.info("Successfully listed services - status #{status}")
      deferred.resolve(data)
    )
    .error((data, status, headers) =>
      @$log.error("Failed to list Services - status #{status}")
      deferred.reject(data);
    )
    deferred.promise

  create: (post) ->
    @$log.debug "create a post"
    @saveOrUpdate('/post', post, @$http.post)

  update: (post) ->
    @$log.debug "update a post"
    @saveOrUpdate('/post', post, @$http.put)

  getById: (permalink) ->
    @$log.debug "getById " + permalink
    deferred = @$q.defer()

    @$http.get("/post/" + permalink)
    .success((data, status, headers) =>
      @$log.info("Successfully get post by Id - status #{status}")
      deferred.resolve(data)
    )
    .error((data, status, headers) =>
      @$log.error("Failed to list Services - status #{status}")
      deferred.reject(data);
    )
    deferred.promise

  getTotal: () ->
    @$log.debug "get size of posts "
    deferred = @$q.defer()

    @$http.get("/posts/size")
    .success((data, status, headers) =>
      @$log.info("Successfully listed services - status #{status}")
      deferred.resolve(data)
    )
    .error((data, status, headers) =>
      @$log.error("Failed to list Services - status #{status}")
      deferred.reject(data);
    )
    deferred.promise

  delete: (permalink) ->
    @$log.debug "delete permalink"
    deferred = @$q.defer()

    @$http.delete("/post/" + permalink)
    .success((data, status, headers) =>
      @$log.info("Successfully listed services - status #{status}")
      deferred.resolve(data)
    )
    .error((data, status, headers) =>
      @$log.error("Failed to list Services - status #{status}")
      deferred.reject(data);
    )
    deferred.promise

  saveOrUpdate: (url, post, func) ->
    deferred = @$q.defer()

    func(url, post)
    .success((data, status, headers) =>
      @$log.info("Successfully created post - status #{status}")
      deferred.resolve(data)
    )
    .error((data, status, headers) =>
      @$log.error("Failed to create post - status #{status}")
      deferred.reject(data);
    )
    deferred.promise


servicesModule.service('PostService', PostService)
