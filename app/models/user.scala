package models

case class User( email: String,
                 displayName: String,
                 firstName: Option[String],
                 lastName: Option[String],
                 password: Option[String],
                 age: Option[String],
                 active: Boolean)

case class LoginForm(email: String,
                      password: String,
                      passwordRepeat: Option[String])


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