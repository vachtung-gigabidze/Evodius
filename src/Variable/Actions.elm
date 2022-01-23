module Variable.Actions exposing (..)
import Url
import Browser
import Http

import Type.Models exposing (FuelConsuption)
import Type.Users exposing (UserData)
import Component.Auth
import Component.Question
type Actions =  
      GotFuelConsuptions (Result Http.Error (List FuelConsuption))
    | UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest
    | ClickMsg
    | OpenPopup
    | AuthMsg Component.Auth.Msg
     -- Hide question component messages
    | QuestionMsg Component.Question.Msg
    | UserTypedMiliage String
    | UserTypedNorma String
    | UserTypedHoudling String
    | Calculate
    -- | OpenPopup
    -- | LoginTyped UserName
    -- | PasswordTyped String
    -- | Login
    -- | QuestionTyped String
    -- | SendQuestion