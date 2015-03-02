package models

import java.util.Date

case class Comment(_id: String,
                    content: String,
                   publishingDate: Date,
                   ipAddress: String,
                   author: String,
                   postKey: String,
                   like: Long,
                   visible: Boolean)

object CommentJsonFormats {

  import play.api.libs.json.Json

  // Generates Writes and Reads for Feed and User thanks to Json Macros
  implicit val contentFormat = Json.format[Comment]
}