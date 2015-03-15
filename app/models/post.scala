package models

import java.util.Date

case class Post(title: String, content: String, publishingDate: Option[Date], url: Option[String], owner: Option[String], permalink: String, activate: Boolean)

object PostJsonFormats {
  import play.api.libs.json.Json

  // Generates Writes and Reads for Feed and User thanks to Json Macros
  implicit val postFormat = Json.format[Post]
}
