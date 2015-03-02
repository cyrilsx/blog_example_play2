package models

case class User( email: String,
                 firstName: Option[String],
                 lastName: Option[String],
                 password: Option[String],
                 active: Boolean)

case class LoginForm(email: String,
                      password: String,
                      passwordRepeat: String)


object UserJsonFormats {
  import play.api.libs.json.Json

  // Generates Writes and Reads for Feed and User thanks to Json Macros
  implicit val userFormat = Json.format[User]
}

object LoginFormJsonFormats {
  import play.api.libs.json.Json

  // Generates Writes and Reads for Feed and User thanks to Json Macros
  implicit val loginFormFormat = Json.format[LoginForm]
}