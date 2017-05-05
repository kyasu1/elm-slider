module Slider3
    exposing
        ( State
        , initialState
        , Msg
        , Config
        , config
        , update
        , subscriptions
        , view
        , next
        , prev
        )

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


type St
    = St (Maybe Direction) (Maybe String) Transit.Transition


type alias State =
    Transit.WithTransition
        { direction : Maybe Direction
        , moving : Maybe String
        }


initialState : State
initialState =
    { transition = Transit.empty
    , direction = Nothing
    , moving = Nothing
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


update : Zipper String -> Msg -> State -> ( State, Cmd Msg, Zipper String )
update images msg state =
    case msg of
        -- NextClick durations ->
        --     let
        --         updatedImages =
        --             case Zipper.next images of
        --                 Just zipper ->
        --                     zipper
        --
        --                 Nothing ->
        --                     Zipper.first images
        --
        --         updatedState =
        --             { state | direction = Just LeftToRight, moving = Just (Zipper.current images) }
        --
        --         ( finalState, cmd ) =
        --             Transit.start TransitMsg SetCurrent durations updatedState
        --     in
        --         ( finalState, cmd, updatedImages )
        NextClick durations ->
            case Zipper.next images of
                Just images ->
                    let
                        updatedState =
                            { state | direction = Just LeftToRight, moving = Just (Zipper.current images) }

                        ( finalState, cmd ) =
                            Transit.start TransitMsg SetCurrent durations updatedState
                    in
                        ( finalState, cmd, images )

                Nothing ->
                    ( state, Cmd.none, images )

        PrevClick durations ->
            let
                updatedImages =
                    case Zipper.previous images of
                        Just zipper ->
                            zipper

                        Nothing ->
                            Zipper.last images

                updatedState =
                    { state | direction = Just RightToLeft, moving = Just (Zipper.current images) }

                ( finalState, cmd ) =
                    Transit.start TransitMsg SetCurrent durations updatedState
            in
                ( finalState, cmd, updatedImages )

        SetCurrent ->
            ( { state | moving = Nothing }, Cmd.none, images )

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
                    ( TransitStyle.compose (TransitStyle.slideIn width) (TransitStyle.slideIn 0) state.transition
                    , -width
                    )

                Just RightToLeft ->
                    ( TransitStyle.compose (TransitStyle.slideIn -width) (TransitStyle.slideIn 0) state.transition
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
            (case state.moving of
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
