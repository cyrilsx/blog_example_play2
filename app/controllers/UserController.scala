package controllers

import javax.inject.Singleton

import models.LoginFormJsonFormats._
import org.mindrot.jbcrypt.BCrypt
import org.slf4j.{Logger, LoggerFactory}
import play.api.libs.concurrent.Execution.Implicits.defaultContext
import play.api.libs.json._
import play.api.mvc._
import play.modules.reactivemongo.MongoController
import play.modules.reactivemongo.json.collection.JSONCollection
import reactivemongo.api.Cursor

import scala.concurrent.Future

/**
 * The Users controllers encapsulates the Rest endpoints and the interaction with the MongoDB, via ReactiveMongo
 * play plugin. This provides a non-blocking driver for mongoDB as well as some useful additions for handling JSon.
 */
@Singleton
class UserController extends Controller with MongoController {

  private final val logger: Logger = LoggerFactory.getLogger(classOf[UserController])

  /*
   * Get a JSONCollection (a Collection implementation that is designed to work
   * with JsObject, Reads and Writes.)
   * Note that the `collection` is not a `val`, but a `def`. We do _not_ store
   * the collection reference to avoid potential problems in development with
   * Play hot-reloading.
   */
  def collection: JSONCollection = db.collection[JSONCollection]("users")

  // ------------------------------------------ //
  // Using case classes + Json Writes and Reads //
  // ------------------------------------------ //

  import models.UserJsonFormats._
  import models._

  def createUser = Action.async(parse.json) {
    request =>
      request.body.validate[LoginForm].map {
        user =>
          if (user.password.isEmpty) {
            Future.successful(BadRequest("password/passwordRepeat is mandatory"))
          } else if (user.password != user.passwordRepeat.getOrElse("")) {
            Future.successful(BadRequest("password are not matching"))
          } else {
            // `user` is an instance of the case class `models.User`
            collection.insert(User(user.email, user.email, Option.empty, Option.empty, Option(BCrypt.hashpw(user.password, BCrypt.gensalt())), Option.empty, active = false)).map {
              lastError =>
                logger.debug(s"Successfully inserted with LastError: $lastError")
                Created(s"User Created")
            }
          }
      }.getOrElse(Future.successful(BadRequest("invalid json")))
  }


  def updateUser = Action.async(parse.json) {
    request =>
      request.body.validate[User].map {
        user =>
          if (user.password.nonEmpty) {
            Future.successful(BadRequest("password cannot be update with a simple edit"))
          } else {
            // `user` is an instance of the case class `models.User`
            collection.update(Json.obj("email" -> user.email), user.copy(password = Option.empty)).map {
              lastError =>
                logger.debug(s"Successfully update User with LastError: $lastError")
                Ok(s"User Updated")
            }
          }
      }.getOrElse(Future.successful(BadRequest("invalid json")))
  }

  def findUsers = Action.async {
    // let's do our query
    val cursor: Cursor[User] = collection.
      // find all
      find(Json.obj("active" -> false)).
      // sort them by creation date
      //      sort(Json.obj("created" -> -1)).
      // perform the query and get a cursor of JsObject
      cursor[User]

    // gather all the JsObjects in a list
    val futureUsersList: Future[List[User]] = cursor.collect[List]()

    // transform the list into a JsArray
    val futurePersonsJsonArray: Future[JsArray] = futureUsersList.map { users =>
      Json.arr(users)
    }
    // everything's ok! Let's reply with the array
    futurePersonsJsonArray.map {
      users =>
        Ok(users(0))
    }
  }


  def getUser(email: String) = Action.async {
    val foundUser = collection.find(Json.obj("email" -> email)).one[User]

    foundUser.map {
      case user: Option[User] => user.map {
        case p: User => Ok(Json.toJson(user))
      }.getOrElse(NotFound)

      case t => InternalServerError("Failure" + t)
    }
  }


  def login = Action.async(parse.json) {
    request =>
      request.body.validate[LoginForm].map {
        loginForm =>
          if (loginForm.password.isEmpty) {
            Future.successful(BadRequest("password cannot be empty"))
          } else {
            processLogin(loginForm)
          }
      }.getOrElse(Future.successful(BadRequest("invalid json format")))
  }

  private def processLogin(loginForm: LoginForm): Future[SimpleResult] = {
    val eventualUser: Future[Option[User]] = collection.find(Json.obj("email" -> loginForm.email)).one[User]
    eventualUser.map {
      user =>
        if (BCrypt.checkpw(loginForm.password, user.get.password.get)) {
          Ok(Json.toJson(user)).withSession(Security.username -> user.get.email)
        } else {
          BadRequest("credential invalid")
        }
    }
  }

  def logout = Action {
    Redirect(controllers.routes.UserController.login).withNewSession.flashing(
      "success" -> "You are now logged out."
    )
  }

}
