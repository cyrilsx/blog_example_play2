package controllers

import javax.inject.Singleton

import org.slf4j.{LoggerFactory, Logger}
import play.api.libs.json.{Json, JsArray}
import play.api.mvc.{Action, Controller}
import play.modules.reactivemongo.MongoController
import play.modules.reactivemongo.json.collection.JSONCollection
import play.api.libs.concurrent.Execution.Implicits.defaultContext

import scala.concurrent.Future
import scala.concurrent.duration._

/**
 * Created by cyril on 06.12.14.
 */
@Singleton
class PostController extends Controller with MongoController {

  private val logger: Logger = LoggerFactory.getLogger(getClass)

  val timeout = play.api.libs.concurrent.Promise.timeout("too long", 1.second)

  def collection: JSONCollection = db.collection[JSONCollection]("post")

  import models._
  import models.PostJsonFormats._

  def findAll = Action.async {
    val futureResults: Future[List[Post]] = collection.find(Json.obj(),
      Json.obj("publishingDate" -> 1))
      .cursor[Post]
      .collect[List]()

    // transform the list into a JsArray
    val futureApplicationJsonArray: Future[JsArray] = futureResults.map { post =>
      Json.arr(post)
    }
    // everything's ok! Let's reply with the array
    futureApplicationJsonArray.map {
      post =>
        Ok(post(0))
    }
  }


  def get(permalink: String) = Action.async {
    val foundPost = collection.find(Json.obj("permalink" -> permalink)).one[Post]

    Future.firstCompletedOf(Seq(foundPost, timeout)).map {
      case post: Post => Ok(Json.toJson(post).toString())
      case t: String => InternalServerError("Failure" + t)
    }
  }

  def create = Action.async(parse.json) {
    request =>
      request.body.validate[Post].map {
        post =>
          collection.insert(post).map {
            lastError =>
              logger.debug(s"Successfully inserted with LastError: $lastError")
              Created(s"Server Created")
          }
      }.getOrElse(Future.successful(BadRequest("invalid json")))
  }


  def update = Action.async(parse.json) {
    request =>
      request.body.validate[Post].map {
        post =>
          // `user` is an instance of the case class `models.User`
          collection.update(Json.obj("permalink" -> post.permalink), post).map {
            lastError =>
              logger.debug(s"Successfully inserted with LastError: $lastError")
              Ok(s"App Updated")
          }
      }.getOrElse(Future.successful(BadRequest("invalid json")))
  }

  def desactivate(permalink: String) = Action.async {
    val foundPost = collection.find(Json.obj("permalink" -> permalink)).one[Post]

    Future.firstCompletedOf(Seq(foundPost, timeout)).map {
      case post: Post => 
        val updatedPost = post.copy(activate = false)
        collection.update(Json.obj("permalink" -> updatedPost.permalink), updatedPost).map {
          lastError =>
            logger.debug(s"Successfully updated with LastError: $lastError")
            Ok(s"Post Updated")
        }
      case t: String => InternalServerError("Failure" + t)
    }
    Future.successful(Ok(s"Server Updated"))
  }

  def delete(permalink: String) = Action.async {
    collection.remove(Json.obj("name" -> permalink))
    Future.successful(Ok(s"Server Updated"))
  }


}
