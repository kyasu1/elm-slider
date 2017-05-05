module Slider6
    exposing
        ( State
        , initialState
        , Config
        , config
        , Direction(..)
        , moveImage
        , view
        )

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import List.Zipper as Zipper exposing (Zipper)
import Transit
import TransitStyle
import Html.CssHelpers
import SliderCss


-- STATE


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



-- CONFIG


type Config msg
    = Config
        { width : Float
        , height : Float
        , move : Direction -> msg
        }


config :
    { width : Float
    , height : Float
    , move : Direction -> msg
    }
    -> Config msg
config { width, height, move } =
    Config
        { width = width
        , height = height
        , move = move
        }



-- UPDATE


type Direction
    = LeftToRight
    | RightToLeft


moveImage : Direction -> State -> State
moveImage direction state =
    case direction of
        LeftToRight ->
            case Zipper.next state.images of
                Just images ->
                    { state | images = images, direction = Just LeftToRight }

                Nothing ->
                    state

        RightToLeft ->
            case Zipper.previous state.images of
                Just images ->
                    { state | images = images, direction = Just RightToLeft }

                Nothing ->
                    state



-- VIEW


{ class } =
    Html.CssHelpers.withNamespace "slider-"


view : Config msg -> State -> Html msg
view (Config { width, height, move }) ({ images } as state) =
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
            slide

        -- ++ TransitStyle.fade state.transition
    in
        div []
            [ div
                [ class [ SliderCss.Outer ]
                ]
                [ button
                    [ class [ SliderCss.ControlPrev ]
                    , onClick (move RightToLeft)
                    , disabled (Zipper.previous images |> Maybe.map (\_ -> False) |> Maybe.withDefault True)
                    ]
                    [ text "<<" ]
                , div
                    [ (case state.direction of
                        Just LeftToRight ->
                            class [ SliderCss.Inner, SliderCss.InnerReverse ]

                        _ ->
                            class [ SliderCss.Inner ]
                      )
                    ]
                    (case moving of
                        Just image ->
                            [ img
                                [ class [ SliderCss.Item ]
                                , style slideWithFade
                                , src image
                                ]
                                []
                            , img
                                [ class [ SliderCss.Item ]
                                , style
                                    (slide
                                        ++ [ ( "left", px offset )
                                           ]
                                    )
                                , src (Zipper.current images)
                                ]
                                []
                            ]

                        Nothing ->
                            [ img
                                [ class [ SliderCss.Item ]
                                , src (Zipper.current images)
                                ]
                                []
                            ]
                    )
                , button
                    [ class [ SliderCss.ControlNext ]
                    , onClick (move LeftToRight)
                    , disabled (Zipper.next images |> Maybe.map (\_ -> False) |> Maybe.withDefault True)
                    ]
                    [ text ">>" ]
                ]
            , listView state
            ]


listView : State -> Html msg
listView ({ images } as state) =
    div [ class [ SliderCss.ImageList ] ]
        (images
            |> Zipper.toList
            |> List.map imageView
        )


imageView : String -> Html msg
imageView image =
    img [ src image, class [ SliderCss.ImageListItem ] ] []


px : Float -> String
px value =
    (toString value) ++ "px"
