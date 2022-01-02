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
import Url exposing (Protocol(..))
import Http
import Json.Decode as D



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
    ( { fuelConsuptions = [] , status = Loading }
    , getFuelConsuptions
    )


subscriptions : Model -> Sub Actions
subscriptions _ =
    Sub.none

type alias Car = 
  { gn : String,
    model : String
  }

type alias FUELCONSUPTION = 
      {
            unitid: String,
            value: Float,
            motorkindwork:String,
            garagenumber: String,
            motorname: String,
            tepmplus: Float,
            temp0_10: Float,
            temp10_20: Float,
            temp20_30: Float,
            temp30_40: Float,
            temp_40: Float
      }

type Request = Loading | Success | Failure

getFuelConsuptions : Cmd Actions
getFuelConsuptions =
  Http.get {
      url = "https://my-json-server.typicode.com/vachtung-gigabidze/Evodius/FUELCONSUPTIONSS"     
      , expect = Http.expectJson GotFuelConsuptions fuelConsuptionsDecoder
  }

fuelConsuptionsDecoder : D.Decoder (List FUELCONSUPTION)  
fuelConsuptionsDecoder  =  D.list decoderFuelConsuption

decoderFuelConsuption : D.Decoder FUELCONSUPTION
decoderFuelConsuption = 
  let
      mainFields =  
        D.map5 FUELCONSUPTION
        (D.field "unitid" D.string)
        (D.field "value" D.float)
        (D.field "nrmmotorkindwork" D.string)
        (D.field "nrmgaragenumber" D.string)
        (D.field "nrmmotorname" D.string)     
  in
    D.map7
      (<|)
      mainFields
      (D.field "tempplus" D.float)
      (D.field "temp0_10" D.float)
      (D.field "temp10_20" D.float)
      (D.field "temp20_30" D.float)
      (D.field "temp30_40" D.float)
      (D.field "temp_40" D.float)


carNumbers : List Car
carNumbers =  [ { gn = "103", model = "спецтранспорт"}
                , { gn = "328", model =""}
                , {gn = "107", model = ""} 
              ]
---------------------------------------- MODEL/UPDATE ----------------------------------------
-- Data central to the application. This application has no data.
type alias Model =
    { fuelConsuptions: List FUELCONSUPTION
    , status : Request }

type Actions =  
      GotFuelConsuptions (Result Http.Error String)
    | UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest

-- type Msg 
--     = UrlChanged Url.Url
--     | LinkClicked Browser.UrlRequest
    

update : Actions -> Model -> (Model, Cmd Actions)
update msg model =  
        case msg of 
          GotFuelConsuptions result ->
            case result of
             Ok _ -> ( {model | fuelConsuptions = [FUELCONSUPTION "1" 2 "3" "4" "5" 1.1 1.1 1.1 1.1 1.1 1.2]}, Cmd.none )
             Err err -> 
              let _ = Debug.log "ошибка тут" err
              in
              ( model, Cmd.none )
   
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
                [E.html <| Icon.css, header, (content model)]

            
        ]

fuelConsuptionsRender: FUELCONSUPTION -> E.Element msg
fuelConsuptionsRender fuelConsuption =  E.el [] <| E.text fuelConsuption.garagenumber        
renderCarNumbers model =
  E.column [E.width E.fill] <| List.map fuelConsuptionsRender model.fuelConsuptions 
---------------------------------------- VIEW ----------------------------------------


-- view : Model -> Browser.Document Msg
view model =
    { title = "Расход топлива"
    , body = bodyRender model      
    }