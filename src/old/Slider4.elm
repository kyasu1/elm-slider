module Slider4
    exposing
        ( State
        , initialState
        , Config
        , Direction(..)
        , config
        , view
        )

import Html exposing (..)
import Html.Attributes exposing (..)
import List.Zipper as Zipper exposing (Zipper)
import Transit
import TransitStyle


type Direction
    = LeftToRight
    | RightToLeft


type alias State =
    { transition : Transit.Transition
    , direction : Maybe Direction
    , images : Zipper String
    }


initialState : List String -> State
initialState images =
    { transition = Transit.empty
    , direction = Nothing
    , images = Zipper.fromList images |> Zipper.withDefault ""
    }


type Config
    = Config
        { width : Float
        , height : Float
        }


config :
    { width : Float
    , height : Float
    }
    -> Config
config { width, height } =
    Config
        { width = width
        , height = height
        }


view : Config -> State -> Html msg
view (Config { width, height }) ({ images } as state) =
    let
        ( slide, moving, offset ) =
            case state.direction of
                Just LeftToRight ->
                    ( TransitStyle.compose (TransitStyle.slideIn width) (TransitStyle.slideIn 0) state.transition
                    , Zipper.before images |> List.reverse |> List.head
                    , -width
                    )

                Just RightToLeft ->
                    ( TransitStyle.compose (TransitStyle.slideIn -width) (TransitStyle.slideIn 0) state.transition
                    , Zipper.after images |> List.head
                    , width
                    )

                Nothing ->
                    ( TransitStyle.fade state.transition, Nothing, 0 )

        slideWithFade =
            slide ++ TransitStyle.fade state.transition
    in
        div
            [ class ""
            , style
                [ ( "overflow", "hidden" )
                , ( "position", "relative" )
                , ( "width", px width )
                , ( "height", px height )
                , ( "border", "solid 1px #999" )
                ]
            ]
            (case moving of
                Just image ->
                    [ img
                        [ style
                            (slideWithFade
                                ++ [ ( "position", "absolute" )
                                   , ( "top", "0" )
                                   , ( "left", "0" )
                                   , ( "width", px width )
                                   , ( "height", px height )
                                   ]
                            )
                        , class "item moving-image"
                        , src image
                        ]
                        []
                    , img
                        [ style
                            (slide
                                ++ [ ( "position", "absolute" )
                                   , ( "top", "0" )
                                   , ( "left", px offset )
                                   , ( "width", px width )
                                   , ( "height", px height )
                                   ]
                            )
                        , class "item zipper-current-image"
                        , src (Zipper.current images)
                        ]
                        []
                    ]

                Nothing ->
                    [ img
                        [ style
                            ([ ( "position", "absolute" )
                             , ( "top", "0" )
                             , ( "left", "0" )
                             , ( "width", px width )
                             , ( "height", px height )
                             ]
                            )
                        , class "item zipper-current-image"
                        , src (Zipper.current images)
                        ]
                        []
                    ]
            )


px : Float -> String
px value =
    (toString value) ++ "px"
