class UserService

  @headers = {'Accept': 'application/json', 'Content-Type': 'application/json'}
  @defaultConfig = {headers: @headers}
  @logged = false
  @user = {}

  constructor: (@$log, @$http, @$q, @LoginNotificationService) ->
    @$log.debug "constructing UserService"

  listUsers: () ->
    @$log.debug "listUsers()"
    deferred = @$q.defer()

    @$http.get("/users")
    .success((data, status, headers) =>
      @$log.info("Successfully listed Users - status #{status}")
      deferred.resolve(data)
    )
    .error((data, status, headers) =>
      @$log.error("Failed to list Users - status #{status}")
      deferred.reject(data);
    )
    deferred.promise

  createUser: (user) ->
    @$log.debug "createUser #{angular.toJson(user, true)}"
    @saveOrUpdate('/user', user, @$http.post)

  updateUser: (user) ->
    @$log.debug "updateUser #{angular.toJson(user, true)}"
    @saveOrUpdate('/user', user, @$http.put)

  saveOrUpdate: (url, user, func) ->
    deferred = @$q.defer()

    func(url, user)
    .success((data, status, headers) =>
      @$log.info("Successfully created post - status #{status}")
      deferred.resolve(data)
    )
    .error((data, status, headers) =>
      @$log.error("Failed to create post - status #{status}")
      deferred.reject(data);
    )
    deferred.promise

  get: (email) ->
    @$log.debug("get info from user #{email}")
    deferred = @$q.defer()

    @$http.get("/user/" + email)
    .success((data, status, headers) =>
      @$log.info("Successfully get user #{email} - status #{status}")
      deferred.resolve(data)
    )
    .error((data, status, headers) =>
      @$log.error("Failed to get user #{email} - status #{status}")
      deferred.reject(data);
    )
    deferred.promise

  login: (loginForm) ->
    @$log.debug "try to login #{loginForm.email}"
    deferred = @$q.defer()

    @$http.post("/login", loginForm)
    .success((data, status, headers) =>
      @$log.info("Successfully login user #{loginForm.email} - status #{status}")
      @user = data
      @logged = @user.email == loginForm.email
      @LoginNotificationService.notify()
      deferred.resolve(data)
    )
    .error((data, status, headers) =>
      @$log.error("Failed to login #{email} - status #{status}")
      deferred.reject(data);
    )
    deferred.promise

  logout: () ->
    @$http.post("/logout")
    @user = {}
    @logged = false
    @LoginNotificationService.notify()


servicesModule.service('UserService', UserService)