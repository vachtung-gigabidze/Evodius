module Main exposing (..)


import Colors as C
import Models exposing (FuelConsuption, renderCarNumbers, fuelConsuptionsDecoder)

import Header exposing (header)
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

import Actions exposing (Actions(..))
import FontAwesome.Attributes as Icon
import FontAwesome.Brands as Icon
import FontAwesome.Icon as Icon exposing (Icon)
import FontAwesome.Layering as Icon
import FontAwesome.Solid as Icon
import FontAwesome.Styles as Icon
import FontAwesome.Svg as SvgIcon
import FontAwesome.Transforms as Icon 
import Footer exposing (footer)


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
    ( { fuelConsuptions = Loading }
    , getFuelConsuptions
    )


subscriptions : Model -> Sub Actions
subscriptions _ =
    Sub.none

type alias Car = 
  { gn : String,
    model : String
  }



type Request = Loading | Success (List FuelConsuption) | Failure

-- getFuelConsuptions : Cmd Actions
getFuelConsuptions =
  Http.get {
      url = "https://my-json-server.typicode.com/vachtung-gigabidze/Evodius/FuelConsuption"     
      , expect = Http.expectJson GotFuelConsuptions fuelConsuptionsDecoder
  }





-- carNumbers : List Car
-- carNumbers =  [ { gn = "103", model = "спецтранспорт"}
--                 , { gn = "328", model =""}
--                 , {gn = "107", model = ""} 
--               ]
---------------------------------------- MODEL/UPDATE ----------------------------------------
-- Data central to the application. This application has no data.
type alias Model =
    {  fuelConsuptions : Request }


    

-- type Msg
--     = UserPressedButton
--     = UrlChanged Url.Url
--     | LinkClicked Browser.UrlRequest
    

update : Actions -> Model -> (Model, Cmd Actions)
update msg model =  
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

bodyRender model = [ E.layout
            [ E.width E.fill
            , E.height E.fill
            
            , EBA.color <| E.rgb255 176 192 200
            , E.inFront <| header
            ]
            <| E.column 
                [E.width E.fill]
                [E.html <| Icon.css, header, (content model), footer]            
        ]

emptyBody =  [ E.layout
            [ E.width E.fill
            , E.height E.fill
            
            , EBA.color <| E.rgb255 176 192 200
           
        ]  <| E.column 
                [E.width E.fill]
                [E.html <| Icon.css] ]        


---------------------------------------- VIEW ----------------------------------------


-- view : Model -> Browser.Document Msg
view model =
  case model.fuelConsuptions of
    Success fuelConsuptions ->
            { title = "Расход топлива"
            , body = bodyRender fuelConsuptions      
            }

    Loading ->
         { title = "Расход топлива"
              , body = emptyBody
            }

    Failure ->
         { title = "Расход топлива"
              , body = emptyBody      
            }
    