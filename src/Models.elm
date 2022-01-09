module Models exposing (..)

import Element as E
import Json.Decode as D
type alias FuelConsuption = 
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
fuelConsuptionsRender: FuelConsuption -> E.Element msg
fuelConsuptionsRender fuelConsuption =  E.el [] <| E.text fuelConsuption.motorkindwork        
renderCarNumbers fuelConsuptions =
  E.column [E.width E.fill] <| List.map fuelConsuptionsRender fuelConsuptions       

decoderFuelConsuption : D.Decoder FuelConsuption
decoderFuelConsuption = 
  let
      mainFields =  
        D.map5 FuelConsuption
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

fuelConsuptionsDecoder : D.Decoder (List FuelConsuption)  
fuelConsuptionsDecoder  =  D.list decoderFuelConsuption