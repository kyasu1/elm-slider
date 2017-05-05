module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import ButtonArrow


type Msg
    = NoOp


type alias Model =
    Int


main : Html Msg
main =
    div [ style [ ( "width", "50px" ), ( "height", "50px" ) ] ]
        [ ButtonArrow.elem ]
