module Main exposing (..)

import Browser
import Browser.Navigation as Navigation
import Element as E
import Element.Background as EBA
import Element.Font as F
import Url
import FontAwesome.Attributes as Icon
import FontAwesome.Brands as Icon
import FontAwesome.Icon as Icon exposing (Icon)
import FontAwesome.Layering as Icon
import FontAwesome.Solid as Icon
import FontAwesome.Styles as Icon
import FontAwesome.Svg as SvgIcon
import FontAwesome.Transforms as Icon



type alias Flags =
    {}

-- The main function of the Elm program
main : Program Flags Model Msg
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
init : Flags -> Url.Url -> Navigation.Key -> (Model, Cmd Msg)
init {} url key =
    ( Model 
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none

type alias Car = 
  { gn : String,
    model : String
  }

carNumbers : List Car
carNumbers =  [ { gn = "103", model = "спецтранспорт"}
                , { gn = "328", model =""}
                , {gn = "107", model = ""} 
              ]
---------------------------------------- MODEL/UPDATE ----------------------------------------
-- Data central to the application. This application has no data.
type alias Model =
    {}


type Msg 
    = UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        LinkClicked browser_request ->
            ( model, Cmd.none )

        UrlChanged url ->
            ( model, Cmd.none )

header : E.Element msg
header = 
  E.row [ E.width E.fill, EBA.color (E.rgb255 222 1 22), E.spacing 20, E.padding 20 ]
        [
           E.el [] (E.html (Icon.viewIcon Icon.truck))
           , E.el [] (E.text "Калькулятор")
           , E.el [] (E.text "v0.0.1")
        ]

content =
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
            ] renderCarNumbers]

bodyRender = [ E.layout
            [ E.width E.fill
            , E.height E.fill
            
            , EBA.color <| E.rgb255 176 192 200
            , E.inFront <| header
            ]
            <| E.column 
                [E.width E.fill]
                [E.html <| Icon.css, header, content]

            
        ]

carRender: Car -> E.Element msg
carRender c =  E.el [] <| E.text c.gn        
renderCarNumbers =
  E.column [E.width E.fill] <| List.map carRender carNumbers 
---------------------------------------- VIEW ----------------------------------------


-- view : Model -> Browser.Document Msg
view model =
    { title = "Расход топлива"
    , body = bodyRender       
    }