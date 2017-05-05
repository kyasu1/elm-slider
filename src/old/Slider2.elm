module Slider2 exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import List.Zipper as Zipper exposing (Zipper)
import Animation exposing (px)


type Msg
    = Next
    | NextClick ( Float, Float )
    | Prev
    | PrevClick ( Float, Float )
    | Animate Animation.Msg


type Direction
    = LeftToRight
    | RightToLeft


type alias State =
    { direction : Maybe Direction
    , slides : Zipper Int
    , currentStyle : Animation.State
    , overlayStyle : Animation.State
    }


initialState : List String -> State
initialState images =
    { direction = Nothing
    , slides = List.range 1 (List.length images) |> Zipper.fromList |> Zipper.withDefault 1
    , currentStyle = Animation.style [ Animation.opacity 1 ]
    , overlayStyle = Animation.style [ Animation.opacity 0, Animation.left (px 600) ]
    }


type Config
    = Config
        { offsets : ( Float, Float )
        }


config :
    { offsets : ( Float, Float ) }
    -> Config
config { offsets } =
    Config
        { offsets = offsets
        }


type Zipped a
    = Zipped Zipper a


update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    case msg of
        NextClick durations ->
            let
                newState =
                    { state
                        | direction = Just RightToLeft
                        , slides = Zipper.next state.slides |> Zipper.withDefault 1
                        , currentStyle = Animation.queue [ Animation.to [ Animation.opacity 0, Animation.left (px -600) ] ] state.currentStyle
                        , overlayStyle = Animation.queue [ Animation.to [ Animation.opacity 1, Animation.left (px 0) ] ] state.overlayStyle
                    }
            in
                ( newState, Cmd.none )

        Animate msg ->
            ( { state
                | currentStyle = Animation.update msg state.currentStyle
                , overlayStyle = Animation.update msg state.overlayStyle
              }
            , Cmd.none
            )

        _ ->
            ( state, Cmd.none )


subscriptions : State -> Sub Msg
subscriptions state =
    Animation.subscription Animate [ state.currentStyle, state.overlayStyle ]


next : ( Float, Float ) -> Msg
next durations =
    NextClick durations


prev : ( Float, Float ) -> Msg
prev durations =
    PrevClick durations


view :
    Config
    -> State
    -> List String
    -> Html msg
view ((Config { offsets }) as config) state images =
    div [] (images |> List.indexedMap (imageView state))


imageView : State -> Int -> String -> Html msg
imageView state index image =
    let
        styles =
            if Zipper.current state.slides == index then
                state.currentStyle
            else
                state.overlayStyle
    in
        img
            (List.concat
                [ Animation.render styles
                , [ style
                        [ ( "position", "absolute" )
                        , ( "top", "0" )
                          -- , ( "left", "0" )
                        , ( "width", "600px" )
                        , ( "height", "320px" )
                        ]
                  , class "photo"
                  , src image
                  ]
                ]
            )
            []
