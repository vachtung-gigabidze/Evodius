module Component.Auth exposing (..)

import Http
import Task
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input


import Json.Encode
import Type.Users exposing (User(..), UserData, decodeUserData)
import Variable.Colors exposing (color)
import Url exposing (Protocol(..))

type alias Model =
  {
      login : String
    , password: String
  }

type Msg
  = LoginTyped String
  | PasswordTyped String
  | Login
  | RequestResult (Result Http.Error UserData)

type Return
  = Authenticated UserData


init : User -> (Model, Cmd Msg, Maybe Return)
init user =
  case user of
    Anonymous ->
      ( initModel, Cmd.none, Nothing)
    User userData ->
      (initModel, Cmd.none, Just <| Authenticated userData)

initModel : Model
initModel =
  { login = "user"
  , password = "123"
  }

update : Msg -> Model -> (Model, Cmd Msg, Maybe Return)
update msg model = 
  case msg of
    LoginTyped value ->
      ({model | login = value}, Cmd.none, Nothing)
    PasswordTyped value ->
      ({model | password = value}, Cmd.none, Nothing)
    Login ->
      (model, authenticate model, Nothing)
    RequestResult (Ok userData) ->
      (model, Cmd.none, Just <| Authenticated userData)
    RequestResult (Err _) -> (model, Cmd.none, Nothing)

view model = 
  layout [ padding 50 ] <|
        column [ spacing 30 ]
            [ Input.text [ width <| maximum 300 fill ]
                { onChange = LoginTyped
                , text = model.text
                , placeholder = Just <| Input.placeholder [] <| text "Type here"
                , label = Input.labelAbove [] <| text "Text input"
                }
            , Input.newPassword [ width <| maximum 300 fill ]
                { onChange = PasswordTyped
                , text = model.password
                , placeholder =
                    Just <|
                        Input.placeholder [] <|
                            text "Enter new password"
                , label = Input.labelAbove [] <| text "New password"
                , show = model.showPassword
                }
            , Input.button
                [ padding 20
                , Background.color color.lightBlue
                , Border.width 2
                , Border.rounded 16
                , Border.color color.blue
                , Border.shadow
                    { offset = ( 4, 4 ), size = 3, blur = 10, color = color.lightGrey }
                , Font.color color.white
                , mouseDown
                    [ Background.color color.white, Font.color color.darkCharcoal ]
                , focused
                    [ Border.shadow
                        { offset = ( 4, 4 ), size = 3, blur = 10, color = color.blue }
                    ]
                ]
                { onPress = Just Login
                , label = text "Button with focus style"
                }
            ]
 
--authenticate : Model -> Cmd Msg
--fetchItems : Cmd Msg
-- authenticate model =
--   Http.post
--     { url = authenticateUrl
--     , body = Http.emptyBody
--     , expect = Http.expectJson (authenticateBody model) decodeUserData
--     }

-- authenticate : Model -> Http.Request (List String)
authenticate model = Cmd.none
--   Http.post  authenticateUrl (Http.jsonBody <| authenticateBody model) decodeUserData
--     -- |> Http.toTask
--     -- |> Task.attempt RequestResult     

authenticateUrl : String
authenticateUrl = "/src/login.json"

authenticateBody : Model -> Json.Encode.Value
authenticateBody { login, password } =
  Json.Encode.object
    [ ("login", Json.Encode.string login )
    , ("password", Json.Encode.string password )
    ]

anonymousView : Element msg
anonymousView = el [] ( text "Anonymous")
userView : UserData -> Element msg
userView userData = el [] ( text userData.name)

