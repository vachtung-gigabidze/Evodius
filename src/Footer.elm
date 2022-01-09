module Footer exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Colors exposing (..)
footer =
    row
        [ width fill
        , padding 10
        , Background.color color.lightBlue
        , Border.widthEach { top = 1, bottom = 0, left = 0, right = 0 }
        , Border.color color.blue
        ]
        [ column [ alignRight, spacing 10 ]
            [ el [ alignRight ] <| text "Services"
            , el [ alignRight ] <| text "About"
            , el [ alignRight ] <| text "Contact"
            ]
        ]