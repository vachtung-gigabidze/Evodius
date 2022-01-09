module Actions exposing (..)
import Url
import Browser
import Http

import Models exposing (FuelConsuption)
type Actions =  
      GotFuelConsuptions (Result Http.Error (List FuelConsuption))
    | UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest
    | ClickMsg