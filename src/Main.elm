module Main exposing (..)


import Variable.Colors as C
import Type.Models exposing (FuelConsuption, renderCarNumbers, fuelConsuptionsDecoder)

import Component.Header exposing (header)
import Browser
import Browser.Navigation as Navigation
import Element as E
import Element.Input as Input
import Element.Background as EBA
import Element.Font as F
import Element.Border as Border
import Url

import Url exposing (Protocol(..))
import Http

import Variable.Actions exposing (Actions(..))
import FontAwesome.Attributes as Icon
import FontAwesome.Brands as Icon
import FontAwesome.Icon as Icon exposing (Icon)
import FontAwesome.Layering as Icon
import FontAwesome.Solid as Icon
import FontAwesome.Styles as Icon
import FontAwesome.Svg as SvgIcon
import FontAwesome.Transforms as Icon 
import Component.Footer exposing (footer)

import Type.Users exposing (UserData)

import Type.Users exposing (User(..))
import Debug exposing (toString)
import Component.Auth
import Component.Question
import Variable.Colors exposing (pallete)


type alias Flags =
    {}

-- The main function of the Elm program
main : Program Flags Model Actions
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }

-- Initializes the Model and sends and Cmd Msg's that should be sent upon 
-- initialization of the poject
init : Flags -> Url.Url -> Navigation.Key -> (Model, Cmd Actions)
init {} url key =
    ( { fuelConsuptions = Loading, user = Anonymous, ui = Nothing, calculator = initCalculator}
    , getFuelConsuptions
    )


initCalculator = {
      miliage = Just 0
    , normaKm = FloatField Nothing ""
    , motorHour = FloatField Nothing ""
    , normaMotorHour = FloatField Nothing ""
    , houdling = FloatField Nothing ""
    , normaHoudling = FloatField Nothing ""
    , consumption = FloatField Nothing ""
    }

subscriptions : Model -> Sub Actions
subscriptions _ =
    Sub.none

type alias Car = 
  { gn : String,
    model : String
  }

type alias Password = String

type Request = Loading | Success (List FuelConsuption) | Failure

type Ui

  -- Hide authentication component model
  = AuthUi Component.Auth.Model

  -- Hide question component model
  | QuestionUi Component.Question.Model

getFuelConsuptions =
  Http.get {
      url = "https://my-json-server.typicode.com/vachtung-gigabidze/Evodius/FuelConsuption"     
      , expect = Http.expectJson GotFuelConsuptions fuelConsuptionsDecoder
  }


---------------------------------------- MODEL/UPDATE ----------------------------------------
-- Data central to the application. This application has no data.
type alias Model =
    { fuelConsuptions : Request
    , user: User
    , ui: Maybe Ui 
    , calculator: Calculator
    }

type alias Calculator = {
    miliage: Maybe Int
  , normaKm: FloatField
  , motorHour: FloatField
  , normaMotorHour: FloatField
  , houdling: FloatField
  , normaHoudling: FloatField
  , consumption: FloatField
  }

type FloatField 
  = FloatField (Maybe Float) String

floatFieldToString : FloatField -> String
floatFieldToString floatField =
  case floatField of
    FloatField Nothing float ->
      float
    FloatField (Just _) float ->
      float


floatValidationStyle floatField =
  case floatField of
    FloatField Nothing float ->
      if float == "" then
        []
      else
        [EBA.color pallete.warning]
    FloatField (Just float) _ ->
      []

updateHelp foo int =
  { foo | bar = int }      

update : Actions -> Model -> (Model, Cmd Actions)
update msg model = 
  case (msg, model.ui) of

  -- Anonymous user message handling section
    (OpenPopup, Nothing) ->
      case Component.Auth.init model.user of
        (authModel, commands, Just (Component.Auth.Authenticated userData)) ->
          let
            (questionModel, questionCommands, _) = Component.Question.init userData
          in
            ( { model | ui = Just <| QuestionUi questionModel, user = User userData }, Cmd.batch [Cmd.map AuthMsg commands, Cmd.map QuestionMsg questionCommands] )

        (authModel, commands, _) ->
          ( { model | ui = Just <| AuthUi authModel }, Cmd.map AuthMsg commands )

  -- Handle authenticate component messages
    (AuthMsg authMsg, Just (AuthUi authModel)) ->
      case Component.Auth.update authMsg authModel of
        (_, commands, Just (Component.Auth.Authenticated userData)) ->
          let
            (questionModel, questionCommands, _) = Component.Question.init userData
          in
            ( { model | ui = Just <| QuestionUi questionModel, user = User userData }, Cmd.batch [Cmd.map AuthMsg commands, Cmd.map QuestionMsg questionCommands] )

        (newAuthModel, commands, _) ->
          ( { model | ui = Just <| AuthUi newAuthModel }, Cmd.map AuthMsg commands )
    _ ->      
        case msg of 
          GotFuelConsuptions result ->
            case result of
             Ok data ->  ( {model | fuelConsuptions = Success data}, Cmd.none )
             Err err -> 
              let _ = Debug.log "ошибка тут" err
              in
              ( model, Cmd.none )
   
          LinkClicked browser_request ->
              ( model, Cmd.none )

          UrlChanged url ->
              ( model, Cmd.none )
          ClickMsg ->
              let _ = Debug.log "НАжАЛИ КНОПКУ"
              in
              ( model, Cmd.none)
          UserTypedMiliage miliageString ->
             let calucator = model.calculator in
              ( {model | calculator = {calucator | miliage =  (String.toInt miliageString)}}, Cmd.none )
          UserTypedNorma  normaString ->
            if String.right 1 normaString == "." then
              let calucator = model.calculator in 
               ( {model | calculator = {calucator | normaKm = FloatField Nothing normaString}}, Cmd.none )
            else
              let
                maybeFloat = 
                  normaString |> String.toFloat
              in
              case maybeFloat of
                Nothing ->
                  let calucator = model.calculator in 
                    ( {model | calculator =  {calucator | normaKm = FloatField Nothing normaString}}, Cmd.none )
                Just f ->
                  let calucator = model.calculator in 
                    ( {model | calculator =  {calucator | normaKm = FloatField (Just f) normaString}}, Cmd.none )
          UserTypedHoudling  houdlingString ->
               ( model, Cmd.none)
          _ ->
            ( model, Cmd.none )
          
---------------------------------------- VIEW ----------------------------------------
content model =
       E.row
          [ E.centerX
          , E.centerY
          , E.spacing 42
          , E.padding 100
          ]
          [E.el
            [ E.centerX
            , E.centerY
            , F.bold
            , F.size 42
            ] (renderCarNumbers model) ]

error404  =
       E.row
          [ E.centerX
          , E.centerY
          , E.spacing 42
          , E.padding 100
          ]
          [E.el
            [ E.centerX
            , E.centerY
            , F.bold
            , F.size 42
            ] (E.text "Error 404") ]


bodyRender model = [ E.layout
            [ E.width E.fill
            , E.height E.fill
            
            , EBA.color <| E.rgb255 176 192 200
            , E.inFront <| header
            ]
            <| E.column 
                [E.width E.fill
                , E.height E.fill]
                [E.html <| Icon.css, header, (calculator model), footer]            
        ]

emptyBody =  [ E.layout
            [ E.width E.fill
            , E.height E.fill
            
            , EBA.color <| E.rgb255 176 192 200
           , E.inFront <| header
        ]  <| E.column 
                [E.width E.fill]
                [E.html <| Icon.css, error404, footer] ]        

calculator model =
       E.row
          [ E.centerX
          , E.centerY
          , E.spacing 42
          , E.padding 100
          ]
          [E.column
            [ E.centerX
            , E.centerY
            , F.bold
            , F.size 42
            ]  <| ( [Input.text [ E.width <| E.maximum 300 E.fill ]
                { onChange = UserTypedMiliage
                , text = toString <|  (case model.calculator.miliage of 
                                        Nothing -> 0 
                                        Just n -> n)
                , placeholder = Just <| Input.placeholder [] <| E.text "Пробег сюда"
                , label = Input.labelAbove [] <| E.text "Пробег"
                }
            , Input.text ([E.width <| E.maximum 300 E.fill ] ++ floatValidationStyle model.calculator.normaKm)
                { onChange = UserTypedNorma
                , text = (floatFieldToString model.calculator.normaKm)
                , placeholder = Just <| Input.placeholder [] <| E.text "Норма"
                , label = Input.labelAbove [] <| E.text "Норма"
                }
            , Input.text [ E.width <| E.maximum 300 E.fill ]
                { onChange = UserTypedHoudling
                , text = toString <|  (case model.calculator.miliage of 
                                        Nothing -> 0 
                                        Just n -> n)
                , placeholder = Just <| Input.placeholder [] <| E.text "Холостой ход"
                , label = Input.labelAbove [] <| E.text "Холостой ход"
                }
           ] )]





-- view : Model -> Browser.Document Msg
view model =
  case model.fuelConsuptions of
    Success fuelConsuptions ->
            { title = "Расход топлива"
            , body = bodyRender model 
                 
            }

    Loading ->
         { title = "Расход топлива"
          , body = bodyRender model
          }

    Failure ->
         { title = "Расход топлива"
              , body = emptyBody      
            }
    