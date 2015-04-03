package controllers

import java.util.Date
import javax.inject.Singleton

import org.slf4j.{Logger, LoggerFactory}
import play.api.libs.concurrent.Execution.Implicits.defaultContext
import play.api.libs.json._
import play.api.mvc.{Action, Controller}
import play.modules.reactivemongo.MongoController
import play.modules.reactivemongo.json.BSONFormats
import play.modules.reactivemongo.json.collection.JSONCollection
import reactivemongo.api.collections.GenericQueryBuilder
import reactivemongo.bson.BSONDocument
import reactivemongo.core.commands.Count

import scala.concurrent.Future
import scala.concurrent.duration._

@Singleton
class PostController extends Controller with MongoController {

  private val logger: Logger = LoggerFactory.getLogger(getClass)

  val timeout = play.api.libs.concurrent.Promise.timeout("too long", 1.second)

  def collection: JSONCollection = db.collection[JSONCollection]("post")

  import models.PostJsonFormats._
  import models._

  def findAll(from: Int, to: Int) = Action.async {
    val queryBuilder: GenericQueryBuilder[JsObject, Reads, Writes] = collection.find(Json.obj())
    queryBuilder.options.skip(from).batchSize(to - from)
    val futureResults: Future[List[Post]] = queryBuilder
      .sort(Json.obj("publishingDate" -> -1))
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

  def size = Action.async {
    val eventualInt: Future[Int] = count(BSONDocument())
    eventualInt.map {
      case size: Int => Ok(Json.toJson(size))
    }
  }

  private def count(query: BSONDocument): Future[Int] = {
    logger.debug(s"Counting documents: " + BSONFormats.toJSON(query))
    val futureCount = collection.db.command(
      Count(
        collection.name,
        Some(query)
      )
    )
    futureCount
  }

  import models.PostJsonFormats._
  import models._

  def get(permalink: String) = Action.async {
    val foundPost = collection.find(Json.obj("permalink" -> permalink)).one[Post]

    foundPost.map {
      case post: Option[Post] => post.map {
        case p: Post => Ok(Json.toJson(post))
        case _ => NotFound
      }.get

      case t => InternalServerError("Failure" + t)
    }
  }

  def create = Action.async(parse.json) {
    request =>
      request.body.validate[Post].map {
        post =>
          collection.insert(post.copy(publishingDate = Option(new Date()))).map {
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
    collection.remove(Json.obj("permalink" -> permalink))
    Future.successful(Ok(s"Server Updated"))
  }


}
