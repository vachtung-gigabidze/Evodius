module Header exposing (..)

import Element as E
import Element.Background as EBA

import Element.Border as Border
import Element.Input as Input
import Element.Font as F
import FontAwesome.Attributes as Icon
import FontAwesome.Brands as Icon
import FontAwesome.Icon as Icon exposing (Icon)
import FontAwesome.Layering as Icon
import FontAwesome.Solid as Icon
import FontAwesome.Styles as Icon
import FontAwesome.Svg as SvgIcon
import FontAwesome.Transforms as Icon 

import Actions exposing (Actions(..))
import Colors as C
header : E.Element Actions
header = 
  E.row [ E.width E.fill, EBA.color (E.rgb255 222 1 22), E.spacing 20, E.padding 20 ]
        [
          Input.button 
              [  E.focused 
                    [EBA.color C.color.lightGrey]
                , E.mouseDown 
                  [ EBA.color C.color.blue
                  , Border.color C.color.blue
                  , F.color C.color.blue
                  ]
                , E.mouseOver
                    [ Border.color C.color.lightGrey
                    ]
              ]
              {
                onPress = Just ClickMsg
                , label = E.el [] (E.html (Icon.viewIcon Icon.truck))
              }
           , E.el [] (E.text "Калькулятор")
           , E.el [] (E.text "v0.0.1")
           , Input.button 
              [  E.focused 
                    [EBA.color C.color.lightGrey]
                , E.mouseDown 
                  [ EBA.color C.color.blue
                  , Border.color C.color.blue
                  , F.color C.color.blue
                  ]
                , E.mouseOver
                    [ Border.color C.color.lightGrey
                    ]
              ]
              {
                onPress = Just ClickMsg
                , label = E.el [] (E.html (Icon.viewIcon Icon.cog))
              }
        ]