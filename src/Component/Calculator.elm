module Component.Calculator exposing (..)

import Element  as E
import Variable.Actions exposing (Actions(..))
import Element.Input as Input
import Element.Background as EBA
import Element.Font as F
import Debug exposing (toString)
import Variable.Colors exposing (pallete)


type alias Calculator = {
    miliage: FloatField
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

floatFieldToFloat: FloatField -> Float
floatFieldToFloat floatField = 
      case floatField of
          FloatField (Just f) _ -> f 
          FloatField Nothing _  -> 0

floatValidationStyle floatField =
  case floatField of
    FloatField Nothing float ->
      if float == "" then
        []
      else
        [EBA.color pallete.warning]
    FloatField (Just float) _ ->
      []
consumptionCalculate: Calculator -> FloatField
consumptionCalculate calculate = 
         let f = (floatFieldToFloat calculate.normaKm * floatFieldToFloat calculate.miliage)
         in FloatField (Just f) ""
        
calculatorView model =
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
            ]  <| [E.row [] [Input.text [ E.width <| E.maximum 300 E.fill ]
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
                    , placeholder = Just <| Input.placeholder [] <| E.text "Норма пробега"
                    , label = Input.labelAbove [] <| E.text "Норма"
                    }]
                , E.row [] [Input.text [ E.width <| E.maximum 300 E.fill ]
                    { onChange = UserTypedMiliage
                    , text = toString <|  (case model.calculator.miliage of 
                                            Nothing -> 0 
                                            Just n -> n)
                    , placeholder = Just <| Input.placeholder [] <| E.text "Моточасы сюда"
                    , label = Input.labelAbove [] <| E.text "Моточасы"
                    }
                , Input.text ([E.width <| E.maximum 300 E.fill ] ++ floatValidationStyle model.calculator.normaKm)
                    { onChange = UserTypedNorma
                    , text = (floatFieldToString model.calculator.normaKm)
                    , placeholder = Just <| Input.placeholder [] <| E.text "Норма м.ч."
                    , label = Input.labelAbove [] <| E.text "Норма моточасы"
                    }]
            , E.row [] [ Input.text [ E.width <| E.maximum 300 E.fill ]
                { onChange = UserTypedHoudling
                , text = toString <|  (case model.calculator.miliage of 
                                        Nothing -> 0 
                                        Just n -> n)
                , placeholder = Just <| Input.placeholder [] <| E.text "Холостой ход"
                , label = Input.labelAbove [] <| E.text "Холостой ход"
                }]
           ] ]
