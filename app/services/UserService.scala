package services


import models.User
import play.api.libs.json.Json
import play.modules.reactivemongo.ReactiveMongoPlugin
import play.modules.reactivemongo.json.collection.JSONCollection
import play.api.Play.current

import scala.concurrent.{Await, ExecutionContext}
import scala.concurrent.duration._
import ExecutionContext.Implicits.global


//@Singleton
object UserService {

  /** Returns the current instance of the driver. */
  def driver = ReactiveMongoPlugin.driver

  /** Returns the current MongoConnection instance (the connection pool manager). */
  def connection = ReactiveMongoPlugin.connection

  /** Returns the default database (as specified in `application.conf`). */
  def db = ReactiveMongoPlugin.db



  def collection: JSONCollection = db.collection[JSONCollection]("users")

  import models.UserJsonFormats._
  /**
   * Blocking Thread operation
   * @param email
   * @return
   */
  def findOneUser(email: String) : Option[User] = {
    Await.result(collection.find(Json.obj("email" -> email)).one[User], 100.millis)
  }

}
