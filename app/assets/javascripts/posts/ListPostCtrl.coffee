class ListPostCtrl
  constructor: (@$log, @$location, @PostService) ->
    @$log.debug "constructing ListPostCtrl"
    @nbElemPage = 10
    @currentPage = 1
    @posts = []
    @pageRange = [1..@totalPage]
    @listAll()

  totalPage: () ->
    return (@PostService.getTotal() /  @nbElemPage) + 1

  listAll: () ->
    @$log.debug "listAll()"

    @PostService.listAll(@currentPage, @nbElemPage)
    .then(
      (data) =>
        @$log.debug "Promise returned #{data.length} post"
        @posts = data
    ,
      (error) =>
        @$log.error "Unable to get Application: #{error}"
    )

  getActive: (elem) ->
    active = if @currentPage != elem then "active" else "disabled"


  changePage: (nbPage) ->
    totalPage = @totalPage()
    minPage = nbPage < 5 ? 0 : nbPage - 5
    maxPage = nbPage + 5 >= totalPage ? totalPage : nbPage + 5
    @pageRange = [minPage..maxPage]
    @currentPage = nbPage
    @listAll()


  delete: (permalink) ->
     @PostService.delete(permalink)
     .then(
       (data) =>
         @$log.debug "Post #{permalink} deleted"
         @listAll()
     ,
       (error) =>
         @$log.debug "Can't delete post #{permalink} deleted"

     )


controllersModule.controller('ListPostCtrl', ListPostCtrl)