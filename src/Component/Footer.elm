module Component.Footer exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Variable.Colors exposing (..)
import Variable.Variables exposing (programName)
footer =
    row
        [ width fill
        , padding 10
        , Background.color pallete.primary
        , Border.widthEach { top = 1, bottom = 0, left = 0, right = 0 }
        , Border.color color.blue
        ]
        [ column [ alignLeft, spacing 10 ]
            [ el [ alignLeft ] <| text programName
            , el [ alignLeft ] <| text "Настройки"
            , el [ alignLeft ] <| text "История"
            ]
        ]