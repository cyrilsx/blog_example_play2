package controllers

import models.User
import play.api.mvc._
import services.UserService

import scala.concurrent.Future

/**
 * Trait for authentication
 */
trait Secured {

  private val userService = UserService

  def username(request: RequestHeader) = request.session.get(Security.username)

  def onUnauthorized(requestHeader: RequestHeader) = Results.Unauthorized

  def withAuth(f: => String => Request[AnyContent] => Result) = {
    Security.Authenticated(username, onUnauthorized) {
      user => Action(request => f(user)(request))
    }
  }

  def withAsyncAuth(f: => String => Request[AnyContent] => Future[SimpleResult]) = {
    Security.Authenticated(username, onUnauthorized) {
      user => Action.async {
        request => f(user)(request)
      }
    }
  }

  def withUser(f: User => Request[AnyContent] => Result) = withAuth { username => implicit request =>
    userService.findOneUser(username).map { user =>
      f(user)(request)
    }.getOrElse(onUnauthorized(request))
  }


}