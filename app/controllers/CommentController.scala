package controllers

import java.util.Date
import javax.inject.Singleton

import models.Comment
import models.CommentJsonFormats.contentFormat
import org.slf4j.{Logger, LoggerFactory}
import play.api.libs.concurrent.Execution.Implicits.defaultContext
import play.api.libs.json.{JsArray, Json}
import play.api.mvc.{Action, Controller}
import play.modules.reactivemongo.MongoController
import play.modules.reactivemongo.json.collection.JSONCollection
import reactivemongo.core.commands.LastError

import scala.concurrent.Future
import scala.concurrent.duration._

@Singleton
class CommentController extends Controller with MongoController with Secured {

  private val logger: Logger = LoggerFactory.getLogger(getClass)

  def collection: JSONCollection = db.collection[JSONCollection]("comment")

  val timeout = play.api.libs.concurrent.Promise.timeout("too long", 1.second)

  def findAll = Action.async {
    val futureResults: Future[List[Comment]] = collection.find(Json.obj(),
      Json.obj("publishingDate" -> 1))
      .cursor[Comment]
      .collect[List]()

    val futureApplicationJsonArray: Future[JsArray] = futureResults.map { comment =>
      Json.arr(comment)
    }

    futureApplicationJsonArray.map {
      comment =>
        Ok(comment(0))
    }
  }

  def findByPost(postId: String) = Action.async {
    val futureResults: Future[List[Comment]] = collection.find(Json.obj("postKey" -> postId),
      Json.obj("publishingDate" -> 1))
      .cursor[Comment]
      .collect[List]()

    val futureApplicationJsonArray: Future[JsArray] = futureResults.map { comment =>
      Json.arr(comment)
    }

    futureApplicationJsonArray.map {
      comment =>
        Ok(comment(0))
    }
  }


  def like(id: String) = Action.async {
    //    withAsyncAuth =>
    collection.update(Json.obj("_id" -> id), Json.obj("$set" -> Json.obj("like" -> 1)))
    Future.successful(Ok("done"))
  }

  def create = Action.async(parse.json) {
    request =>
      request.body.validate[Comment].map {
        comment =>
          collection.insert(comment).map {
            lastError =>
              logger.debug(s"Successfully inserted with LastError: $lastError")
              Created(s"Server Created")
          }
      }.getOrElse(Future.successful(BadRequest("invalid json")))
  }


  def update = Action.async(parse.json) {
    request =>
      request.body.validate[Comment].map {
        comment =>
          collection.update(Json.obj("_id" -> comment._id), comment.copy(publishingDate = new Date())).map {
            lastError =>
              logger.debug(s"Successfully inserted with LastError: $lastError")
              Ok(s"App Updated")
          }
      }.getOrElse(Future.successful(BadRequest("invalid json")))
  }

  def activate(id: String) = Action.async {
    collection.update(Json.obj("_id" -> id), Json.obj("activate" -> false)).map {
      lastError =>
        logger.debug(s"Successfully inserted with LastError: $lastError")
        Ok(s"App Updated")
    }
  }

  def delete(id: String) = Action.async {
    collection.remove(Json.obj("_id" -> id))
    Future.successful(Ok(s"Comment Removed"))
  }

}
