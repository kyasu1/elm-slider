module Slider
    exposing
        ( Action
        , Config
        , State
        , config
        , initialState
        , moveImage
        , view
        )

{-|

@docs Action, Config, State
@docs config, initialState, moveImage, view

-}

-- import Css.Transitions as T expsoing (transition)

import Css exposing (..)
import Css.Media as Media exposing (only, screen, withMedia)
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attributes exposing (class, css, src, style)
import Html.Styled.Events exposing (onClick)
import TouchEvents exposing (Direction(..), Touch, TouchEvent(..))


btnRight : String
btnRight =
    "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz48c3ZnIHdpZHRoPSIxN3B4IiBoZWlnaHQ9IjIycHgiIHZpZXdCb3g9IjAgMCAxNyAyMiIgdmVyc2lvbj0iMS4xIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIj4gICAgICAgIDx0aXRsZT5hbmdsZWQtcmlnaHQ8L3RpdGxlPiAgICA8ZGVzYz5DcmVhdGVkIHdpdGggU2tldGNoLjwvZGVzYz4gICAgPGRlZnM+PC9kZWZzPiAgICA8ZyBpZD0iUGFnZS0xIiBzdHJva2U9Im5vbmUiIHN0cm9rZS13aWR0aD0iMSIgZmlsbD0ibm9uZSIgZmlsbC1ydWxlPSJldmVub2RkIj4gICAgICAgIDxnIGlkPSIyNCIgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoLTQuMDAwMDAwLCAtMS4wMDAwMDApIj4gICAgICAgICAgICA8ZyBpZD0iYW5nbGVkLXJpZ2h0Ij4gICAgICAgICAgICAgICAgPHJlY3QgaWQ9IlJlY3RhbmdsZSIgeD0iMCIgeT0iMCIgd2lkdGg9IjI0IiBoZWlnaHQ9IjI0Ij48L3JlY3Q+ICAgICAgICAgICAgICAgIDxwb2x5Z29uIGlkPSJpY29uIiBzdHJva2U9IiM5Nzk3OTciIGZpbGw9IiNGRkZGRkYiIHBvaW50cz0iNyAyIDIxIDEyIDcgMjIgNSAxOSAxNSAxMiA1IDUiPjwvcG9seWdvbj4gICAgICAgICAgICA8L2c+ICAgICAgICA8L2c+ICAgIDwvZz48L3N2Zz4="


btnLeft : String
btnLeft =
    "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz48c3ZnIHdpZHRoPSIxN3B4IiBoZWlnaHQ9IjIycHgiIHZpZXdCb3g9IjAgMCAxNyAyMiIgdmVyc2lvbj0iMS4xIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHhtbG5zOnhsaW5rPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5L3hsaW5rIj4gICAgICAgIDx0aXRsZT5hbmdsZWQtbGVmdDwvdGl0bGU+ICAgIDxkZXNjPkNyZWF0ZWQgd2l0aCBTa2V0Y2guPC9kZXNjPiAgICA8ZGVmcz48L2RlZnM+ICAgIDxnIGlkPSJQYWdlLTEiIHN0cm9rZT0ibm9uZSIgc3Ryb2tlLXdpZHRoPSIxIiBmaWxsPSJub25lIiBmaWxsLXJ1bGU9ImV2ZW5vZGQiPiAgICAgICAgPGcgaWQ9IjI0IiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgtNS4wMDAwMDAsIC0xLjAwMDAwMCkiPiAgICAgICAgICAgIDxnIGlkPSJhbmdsZWQtbGVmdCI+ICAgICAgICAgICAgICAgIDxyZWN0IGlkPSJSZWN0YW5nbGUiIHg9IjAiIHk9IjAiIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCI+PC9yZWN0PiAgICAgICAgICAgICAgICA8cG9seWdvbiBpZD0iaWNvbiIgc3Ryb2tlPSIjOTc5Nzk3IiBmaWxsPSIjRkZGRkZGIiB0cmFuc2Zvcm09InRyYW5zbGF0ZSgxMy4wMDAwMDAsIDEyLjAwMDAwMCkgc2NhbGUoLTEsIDEpIHRyYW5zbGF0ZSgtMTMuMDAwMDAwLCAtMTIuMDAwMDAwKSAiIHBvaW50cz0iNyAyIDIxIDEyIDcgMjIgNSAxOSAxNSAxMiA1IDUiPjwvcG9seWdvbj4gICAgICAgICAgICA8L2c+ICAgICAgICA8L2c+ICAgIDwvZz48L3N2Zz4="



-- STATE


{-| -}
type alias State =
    { current : Int
    , touch : Maybe TouchEvents.Touch
    }


{-| -}
initialState : State
initialState =
    { current = 0
    , touch = Nothing
    }



-- CONFIG


{-| -}
type Config msg
    = Config
        { move : Action -> msg
        }


{-| -}
config :
    { move : Action -> msg
    }
    -> Config msg
config { move } =
    Config
        { move = move
        }



-- UPDATE


{-| -}
type Action
    = Next
    | Prev
    | SetCurrent Int
    | OnTouchStart TouchEvents.Touch
    | OnTouchEnd TouchEvents.Touch Int


{-| -}
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


{-| <http://csscience.com/responsiveslidercss3/>
-}
view : Config msg -> State -> List String -> Html msg
view (Config { move }) { current } images =
    let
        styleButton =
            [ alignItems center
            , opacity (int 1)
            , width (Css.rem 4)
            , height (pct 100)
            , position absolute
            , top zero
            , zIndex (int 999)
            , justifyContent center
            ]

        styleButtonPrev =
            let
                display_ =
                    if current == 0 then
                        display none
                    else
                        displayFlex
            in
            [ left zero ] ++ styleButton ++ [ display_ ]

        styleButtonNext =
            let
                display_ =
                    if current == List.length images - 1 then
                        display none
                    else
                        displayFlex
            in
            [ right zero ] ++ styleButton ++ [ display_ ]

        styleButtonImg =
            [ verticalAlign top
            , width (Css.rem 2)
            , height (Css.rem 2)
            , maxWidth (pct 100)
            , maxHeight (pct 100)
            , display inline
            , cursor pointer
            ]
    in
    div [ css [ displayFlex, flexDirection column, maxWidth (pct 100), overflow hidden ] ]
        [ div
            [ css [ position relative, height auto, width (pct 100) ]
            , class "relative w-100-ns h-auto"
            ]
            [ span [ style [ ( "display", "block" ), ( "padding-top", "100%" ) ] ] []
            , div [ css styleButtonPrev ]
                [ a [ onClick (move Prev) ]
                    [ img [ src btnLeft, css styleButtonImg ] []
                    ]
                ]
            , div
                [ css
                    [ position absolute
                    , top zero
                    , displayFlex
                    , overflow hidden
                    , marginLeft (pct <| toFloat <| current * -100)
                    , marginRight (pct <| toFloat <| (List.length images - current - 1) * -100)
                    ]
                , style
                    [ ( "transition", "all 0.5s ease-in" )
                    ]

                -- , TouchEvents.onTouchEvent TouchEvents.TouchStart (\e -> move (OnTouchStart e))
                -- , TouchEvents.onTouchEvent TouchEvents.TouchEnd (\e -> move (OnTouchEnd e (List.length images)))
                ]
                (List.indexedMap (stage current) images)
            , div [ css styleButtonNext ]
                [ a
                    [ onClick (move Next) ]
                    [ img [ src btnRight, css styleButtonImg ] []
                    ]
                ]
            ]
        , dots move current images
        ]


stage : Int -> Int -> String -> Html msg
stage current index image =
    div [ css [ width (pct 100) ] ]
        [ img
            [ src image
            , css [ width (pct 100) ]
            ]
            []
        ]


dots : (Action -> msg) -> Int -> List String -> Html msg
dots move current images =
    let
        mobile =
            [ displayFlex
            , justifyContent spaceAround
            , marginTop (Css.rem 1)
            , width (pct 50)
            , alignSelf center
            ]

        ns =
            [ mediaNs
                [ flexWrap wrap
                , width (pct 100)
                , justifyContent start
                ]
            ]
    in
    div
        [ css (mobile ++ ns)
        ]
        (List.indexedMap (dotsItem move current) images)


dotsItem : (Action -> msg) -> Int -> Int -> String -> Html msg
dotsItem move current index image =
    let
        mobile =
            [ borderRadius (pct 50)
            , height (Css.rem 1)
            , width (Css.rem 1)
            , backgroundColor <| rgba 0 0 0 0.8
            ]

        ns =
            [ mediaNs
                [ borderRadius zero
                , width (pct 20)
                , height auto
                ]
            ]

        active =
            [ opacity (int 1)
            , border3 (px 1) solid (rgba 0 0 0 0.5)
            , boxSizing borderBox
            ]

        nonactive =
            [ opacity (int 1)
            , border3 (px 1) solid (rgba 255 255 255 1.0)
            , boxSizing borderBox
            , cursor pointer
            ]

        dot =
            [ display none, mediaNs [ display block ], maxWidth (pct 100), height auto ]
    in
    if current == index then
        div
            [ css (mobile ++ ns ++ active)
            ]
            [ img [ src image, css dot ] []
            ]
    else
        div
            [ onClick (move (SetCurrent index))
            , css (mobile ++ ns ++ nonactive)
            ]
            [ img [ src image, css dot ] []
            ]


mediaNs : List Style -> Style
mediaNs =
    withMedia [ only screen [ Media.minWidth (px 480) ] ]
