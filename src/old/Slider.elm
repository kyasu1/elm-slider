module Slider exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import List.Zipper as Zipper exposing (Zipper)
import Transit
import TransitStyle


type Msg
    = SetCurrent
    | NextClick ( Float, Float )
    | PrevClick ( Float, Float )
    | TransitMsg (Transit.Msg Msg)


type Direction
    = LeftToRight
    | RightToLeft


type alias State =
    Transit.WithTransition
        { direction : Maybe Direction
        , current : String
        }


initialState : State
initialState =
    { transition = Transit.empty
    , direction = Nothing
    , current = ""
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


type Zipped a
    = Zipped Zipper a


update : Zipper String -> Msg -> State -> ( State, Cmd Msg, Zipper String )
update images msg state =
    case msg of
        NextClick durations ->
            let
                updatedImages =
                    case Zipper.next images of
                        Just zipper ->
                            zipper

                        Nothing ->
                            Zipper.first images

                updatedState =
                    { state | direction = Just LeftToRight }

                ( finalState, cmd ) =
                    Transit.start TransitMsg SetCurrent durations updatedState
            in
                ( finalState, cmd, updatedImages )

        PrevClick durations ->
            let
                updatedImages =
                    case Zipper.previous images of
                        Just zipper ->
                            zipper

                        Nothing ->
                            Zipper.last images

                updatedState =
                    { state | direction = Just RightToLeft }

                ( finalState, cmd ) =
                    Transit.start TransitMsg SetCurrent durations updatedState
            in
                ( finalState, cmd, updatedImages )

        SetCurrent ->
            ( { state | current = Zipper.current images }, Cmd.none, images )

        TransitMsg msg ->
            let
                ( finalState, cmd ) =
                    Transit.tick TransitMsg msg state
            in
                ( finalState, cmd, images )


subscriptions : State -> Sub Msg
subscriptions state =
    Transit.subscriptions TransitMsg state


next : ( Float, Float ) -> Msg
next durations =
    NextClick durations


prev : ( Float, Float ) -> Msg
prev durations =
    PrevClick durations


view : Config -> State -> Zipper String -> Html msg
view ((Config { width, height }) as config) state images =
    let
        ( slide, offset ) =
            case state.direction of
                Just LeftToRight ->
                    ( TransitStyle.compose (TransitStyle.slideIn width) (TransitStyle.slideOut 0) state.transition
                    , -width
                    )

                Just RightToLeft ->
                    ( TransitStyle.compose (TransitStyle.slideIn -width) (TransitStyle.slideOut 0) state.transition
                    , width
                    )

                Nothing ->
                    ( TransitStyle.fade state.transition, 0 )

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
            [ img
                [ style
                    (slide
                        ++ [ ( "position", "absolute" )
                           , ( "top", "0" )
                           , ( "left", "0" )
                           , ( "width", px width )
                           , ( "height", px height )
                           ]
                    )
                , class "item current"
                , src state.current
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
                , class "item overlay"
                , src (Zipper.current images)
                ]
                []
            ]


px : Float -> String
px value =
    (toString value) ++ "px"
