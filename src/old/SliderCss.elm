module SliderCss exposing (..)

import Css exposing (..)
import Css.Elements exposing (body, li)
import Css.Namespace exposing (namespace)


type CssClasses
    = Outer
    | Inner
    | InnerReverse
    | ControlPrev
    | ControlNext
    | Item
    | ImageList
    | ImageListItem


carouselControl =
    [ width (px 30)
    , borderStyle none
    , backgroundColor transparent
    , color (hex "333333")
    , fontSize (px 40)
    , textAlign center
    , opacity (num 0.5)
    , hover [ opacity (num 1.0) ]
    ]



--    [ position absolute
--    , top (px 0)
--    , bottom (px 0)
--    , displayFlex
--    , alignItems center
--    , justifyContent center
--    , width (pct 15)
--    , color (hex "ffffff")
--    , textAlign center
--    , opacity (num 0.5)
--    ]


css =
    (stylesheet << namespace "slider-") styles


styles =
    [ class Outer
        [ displayFlex
        , alignItems stretch
        , width (pct 90)
        , margin auto
        ]
    , class ControlNext carouselControl
    , class ControlPrev carouselControl
    , class Inner
        [ position relative
        , overflow hidden
        , width (px 600)
        , displayFlex
        , flexWrap noWrap
        , flexDirection row
        ]
    , class InnerReverse
        [ flexDirection rowReverse
        ]
    , class Item
        [ display inlineBlock
        , width (px 600)
        , height (px 600)
        ]
    , class ImageList
        [ displayFlex
        ]
    , class ImageListItem
        [ width (px 60)
        , height (px 60)
        ]
    ]
