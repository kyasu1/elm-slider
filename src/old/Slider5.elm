module Slider5
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
            slide ++ TransitStyle.fade state.transition
    in
        div []
            [ button [ onClick (move RightToLeft), disabled (Zipper.previous images |> Maybe.map (\_ -> False) |> Maybe.withDefault True) ] [ text "Prev" ]
            , button [ onClick (move LeftToRight), disabled (Zipper.next images |> Maybe.map (\_ -> False) |> Maybe.withDefault True) ] [ text "Next" ]
            , div
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
                                (slideWithFade ++ (imageStyle { left = 0, width = width, height = height }))
                            , class "item moving-image"
                            , src image
                            ]
                            []
                        , img
                            [ style
                                (slide ++ (imageStyle { left = offset, width = width, height = height }))
                            , class "item zipper-current-image"
                            , src (Zipper.current images)
                            ]
                            []
                        ]

                    Nothing ->
                        [ img
                            [ style (imageStyle { left = 0, width = width, height = height })
                            , class "item zipper-current-image"
                            , src (Zipper.current images)
                            ]
                            []
                        ]
                )
            ]


imageStyle : { left : Float, width : Float, height : Float } -> List ( String, String )
imageStyle { left, width, height } =
    [ ( "position", "absolute" )
    , ( "top", "0" )
    , ( "left", px left )
    , ( "width", px width )
    , ( "height", px height )
    ]


px : Float -> String
px value =
    (toString value) ++ "px"
