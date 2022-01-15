module Type.Users exposing (..)
import Json.Decode
type alias UserData = 
  {
      id: Int
    , name: String
  }

type User = Anonymous | User UserData


decodeUserData : Json.Decode.Decoder UserData
decodeUserData =
  Json.Decode.map2 UserData
    ( Json.Decode.field "id" Json.Decode.int )
    ( Json.Decode.field "name" Json.Decode.string )
