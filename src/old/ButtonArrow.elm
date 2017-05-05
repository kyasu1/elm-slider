module ButtonArrow exposing (..)

import Html exposing (Html)
import Color
import TypedSvg as Svg exposing (..)
import TypedSvg.Attributes as Svg exposing (..)
import TypedSvg.Types exposing (px, Transform(..))


elem : Html msg
elem =
    svg
        [ viewBox 0 0 100 100
        ]
        [ rect
            [ x (px 5)
            , y (px 5)
            , width (px 90)
            , height (px 90)
            , rx (px 8)
            , fill <| Color.rgba 216 216 216 1.0
            , strokeDasharray "120, 420"
            , strokeDashoffset "-500"
            , strokeWidth (px 8)
            , stroke <| Color.rgba 255 255 255 0
            ]
            []
        , polygon
            [ stroke <| Color.rgba 216 216 216 1.0
            , fill <| Color.rgba 51 51 51 1.0
            , points [ ( 45, 5 ), ( 83.9711432, 72.5 ), ( 6.02885683, 72.5 ) ]
            , transform [ Translate 45.0 50.0, Rotate 90 0 0, Translate -45 -50 ]
            ]
            []
        ]
