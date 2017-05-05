module Slider
    exposing
        ( State
        , initialState
        , Config
        , config
        , Action
        , moveImage
        , view
        )

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import TouchEvents exposing (TouchEvent(..), Direction(..), Touch)


btnRight =
    "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz48c3ZnIHdpZHRoPSIxN3B4IiBoZWlnaHQ9IjIycHgiIHZpZXdCb3g9IjAgMCAxNyAyMiIgdmVyc2lvbj0iMS4xIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIj4gICAgICAgIDx0aXRsZT5hbmdsZWQtcmlnaHQ8L3RpdGxlPiAgICA8ZGVzYz5DcmVhdGVkIHdpdGggU2tldGNoLjwvZGVzYz4gICAgPGRlZnM+PC9kZWZzPiAgICA8ZyBpZD0iUGFnZS0xIiBzdHJva2U9Im5vbmUiIHN0cm9rZS13aWR0aD0iMSIgZmlsbD0ibm9uZSIgZmlsbC1ydWxlPSJldmVub2RkIj4gICAgICAgIDxnIGlkPSIyNCIgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoLTQuMDAwMDAwLCAtMS4wMDAwMDApIj4gICAgICAgICAgICA8ZyBpZD0iYW5nbGVkLXJpZ2h0Ij4gICAgICAgICAgICAgICAgPHJlY3QgaWQ9IlJlY3RhbmdsZSIgeD0iMCIgeT0iMCIgd2lkdGg9IjI0IiBoZWlnaHQ9IjI0Ij48L3JlY3Q+ICAgICAgICAgICAgICAgIDxwb2x5Z29uIGlkPSJpY29uIiBzdHJva2U9IiM5Nzk3OTciIGZpbGw9IiNGRkZGRkYiIHBvaW50cz0iNyAyIDIxIDEyIDcgMjIgNSAxOSAxNSAxMiA1IDUiPjwvcG9seWdvbj4gICAgICAgICAgICA8L2c+ICAgICAgICA8L2c+ICAgIDwvZz48L3N2Zz4="


btnLeft =
    "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz48c3ZnIHdpZHRoPSIxN3B4IiBoZWlnaHQ9IjIycHgiIHZpZXdCb3g9IjAgMCAxNyAyMiIgdmVyc2lvbj0iMS4xIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIj4gICAgICAgIDx0aXRsZT5hbmdsZWQtbGVmdDwvdGl0bGU+ICAgIDxkZXNjPkNyZWF0ZWQgd2l0aCBTa2V0Y2guPC9kZXNjPiAgICA8ZGVmcz48L2RlZnM+ICAgIDxnIGlkPSJQYWdlLTEiIHN0cm9rZT0ibm9uZSIgc3Ryb2tlLXdpZHRoPSIxIiBmaWxsPSJub25lIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiPiAgICAgICAgPGcgaWQ9IjI0IiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgtNS4wMDAwMDAsIC0xLjAwMDAwMCkiPiAgICAgICAgICAgIDxnIGlkPSJhbmdsZWQtbGVmdCI+ICAgICAgICAgICAgICAgIDxyZWN0IGlkPSJSZWN0YW5nbGUiIHg9IjAiIHk9IjAiIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCI+PC9yZWN0PiAgICAgICAgICAgICAgICA8cG9seWdvbiBpZD0iaWNvbiIgc3Ryb2tlPSIjOTc5Nzk3IiBmaWxsPSIjRkZGRkZGIiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgxMy4wMDAwMDAsIDEyLjAwMDAwMCkgc2NhbGUoLTEsIDEpIHRyYW5zbGF0ZSgtMTMuMDAwMDAwLCAtMTIuMDAwMDAwKSAiIHBvaW50cz0iNyAyIDIxIDEyIDcgMjIgNSAxOSAxNSAxMiA1IDUiPjwvcG9seWdvbj4gICAgICAgICAgICA8L2c+ICAgICAgICA8L2c+ICAgIDwvZz48L3N2Zz4="



-- STATE


type alias State =
    { current : Int
    , touch : Maybe TouchEvents.Touch
    }


initialState : State
initialState =
    { current = 0
    , touch = Nothing
    }



-- CONFIG


type Config msg
    = Config
        { move : Action -> msg
        }


config :
    { move : Action -> msg
    }
    -> Config msg
config { move } =
    Config
        { move = move
        }



-- UPDATE


type Action
    = Next
    | Prev
    | SetCurrent Int
    | OnTouchStart TouchEvents.Touch
    | OnTouchEnd TouchEvents.Touch Int


moveImage : Action -> State -> State
moveImage action state =
    case action of
        Next ->
            { state | current = state.current + 1 }

        Prev ->
            { state | current = state.current - 1 }

        SetCurrent index ->
            { state | current = index }

        OnTouchStart touchEvent ->
            { state | touch = Just touchEvent }

        OnTouchEnd touchEvent length ->
            state.touch
                |> Maybe.andThen
                    (\s ->
                        if touchEvent.clientX - s.clientX > 100 then
                            Just { state | current = clamp 0 (length - 1) (state.current - 1), touch = Nothing }
                        else if touchEvent.clientX - s.clientX < -100 then
                            Just { state | current = clamp 0 (length - 1) (state.current + 1), touch = Nothing }
                        else
                            Just state
                    )
                |> Maybe.withDefault state



-- VIEW


{-|
  http://csscience.com/responsiveslidercss3/
-}
view : Config msg -> State -> List String -> Html msg
view (Config { move }) { current } images =
    let
        left =
            current * (-100) |> pct

        right =
            ((List.length images) - current - 1) * (-100) |> pct

        prevDisabled =
            if current == 0 then
                class "disabled"
            else
                class ""

        nextDisabled =
            if current == (List.length images) - 1 then
                class "disabled"
            else
                class ""
    in
        div [ class "elm-slider--view" ]
            [ div
                [ class "elm-slider--outer"
                ]
                [ div [ class "elm-slider--prev" ]
                    [ a
                        [ onClick (move Prev)
                        , prevDisabled
                        ]
                        [ img [ src btnLeft ] []
                        ]
                    ]
                , div
                    [ class "elm-slider--inner"
                    , style [ ( "margin-left", left ), ( "margin-right", right ) ]
                    , TouchEvents.onTouchEvent TouchEvents.TouchStart (\e -> move (OnTouchStart e))
                    , TouchEvents.onTouchEvent TouchEvents.TouchEnd (\e -> move (OnTouchEnd e (List.length images)))
                    ]
                    (List.indexedMap (stage current) images)
                , div [ class "elm-slider--next" ]
                    [ a
                        [ onClick (move Next)
                        , nextDisabled
                        ]
                        [ img [ src btnRight ] []
                        ]
                    ]
                ]
            , dots move current images
            ]


stage : Int -> Int -> String -> Html msg
stage current index image =
    let
        styles =
            if current == index then
                [ ( "flex", "1" ) ]
            else
                [ ( "flex", "0" ) ]
    in
        div [ class "elm-slider--image" ]
            [ img
                [ src image
                ]
                []
            ]


dots : (Action -> msg) -> Int -> List String -> Html msg
dots move current images =
    div
        [ class "elm-slider--dots"
        ]
        (List.indexedMap (dotsItem move current) images)


dotsItem : (Action -> msg) -> Int -> Int -> String -> Html msg
dotsItem move current index image =
    if current == index then
        div [ style [ ( "opacity", "1" ) ] ]
            [ img [ src image ] []
            ]
    else
        div
            [ onClick (move (SetCurrent index))
            , style [ ( "opacity", "0.5" ) ]
            ]
            [ img [ src image ] []
            ]


px : Int -> String
px value =
    (toString value) ++ "px"


pct : Int -> String
pct value =
    (toString value) ++ "%"


vw : Int -> String
vw value =
    (toString value) ++ "vw"
