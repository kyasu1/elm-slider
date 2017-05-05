module Slider7
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
    "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzIiIGhlaWdodD0iMzIiIHZpZXdCb3g9IjAgMCAzMiAzMiIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cGF0aCBkPSJNMTIgOC45OWMwLS40MjMuMjA0LS43MjIuNjEtLjg5Ny40MDgtLjE3My43NzItLjEwNCAxLjA5Mi4yMWw3LjAwNiA2Ljk3NGMuMjAyLjIuMjk4LjQzNy4yODcuNzE2IDAgLjI2Ny0uMDk2LjQ5OC0uMjg3LjY5bC03LjAwNiA3Yy0uMzIuMzItLjY4NC4zOS0xLjA5Mi4yMS0uNDA2LS4xNzUtLjYxLS40ODMtLjYxLS45MjNWOC45OXoiIGZpbGw9IiNmZmZmZmYiIG9wYWNpdHk9IjAuOCIgZmlsbC1ydWxlPSJldmVub2RkIi8+PC9zdmc+"



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
        { width : Int
        , height : Int
        , move : Action -> msg
        }


config :
    { width : Int
    , height : Int
    , move : Action -> msg
    }
    -> Config msg
config { width, height, move } =
    Config
        { width = width
        , height = height
        , move = move
        }



-- UPDATE


type Action
    = Next
    | Prev
    | SetCurrent Int
    | OnTouchStart TouchEvents.Touch
    | OnTouchEnd TouchEvents.Touch


moveImage : Action -> State -> State
moveImage action state =
    case Debug.log "moveImage:" action of
        Next ->
            { state | current = state.current + 1 }

        Prev ->
            { state | current = state.current - 1 }

        SetCurrent index ->
            { state | current = index }

        OnTouchStart touchEvent ->
            { state | touch = Just touchEvent }

        OnTouchEnd touchEvent ->
            state.touch
                |> Maybe.andThen
                    (\s ->
                        if touchEvent.clientX > s.clientX then
                            Just { state | current = state.current - 1, touch = Nothing }
                        else if touchEvent.clientX < s.clientX then
                            Just { state | current = state.current + 1, touch = Nothing }
                        else
                            Just state
                    )
                |> Maybe.withDefault state



-- VIEW


view : Config msg -> State -> List String -> Html msg
view (Config { width, height, move }) { current } images =
    let
        left =
            current * (-600) |> toFloat

        prevDisabled =
            current == 0

        nextDisabled =
            current == (List.length images) - 1
    in
        div []
            [ div
                [ class "elm-slider--outer"
                , TouchEvents.onTouchEvent TouchEvents.TouchStart (\e -> move (OnTouchStart e))
                , TouchEvents.onTouchEvent TouchEvents.TouchEnd (\e -> move (OnTouchEnd e))
                ]
                [ div [ class "elm-slider--prev" ]
                    [ a
                        [ onClick (move Prev)
                        , disabled prevDisabled
                        ]
                        [ img [ src btnRight ] []
                        ]
                    ]
                , div
                    [ class "elm-slider--inner"
                    ]
                    (List.indexedMap (iv width current) images)
                , div [ class "elm-slider--next" ]
                    [ a
                        [ onClick (move Next)
                        , disabled nextDisabled
                        ]
                        [ img [ src btnRight ] []
                        ]
                    ]
                ]
            , imagesListView move images
            ]


iv : Int -> Int -> Int -> String -> Html msg
iv width current index image =
    let
        left =
            if width > 600 then
                (index - current) * 600 |> toString
            else
                (index - current) * width |> toString

        class_ =
            if current == index then
                "show"
            else
                ""
    in
        img
            [ src image
              --            , style [ ( "left", left ++ "px" ) ]
            , class class_
            ]
            []


imagesListView : (Action -> msg) -> List String -> Html msg
imagesListView move images =
    div
        [ style
            [ ( "display", "flex" )
            , ( "flex-wrap", "wrap" )
            ]
        ]
        (List.indexedMap (imagesListItemView move) images)


imagesListItemView : (Action -> msg) -> Int -> String -> Html msg
imagesListItemView move index image =
    div
        [ style
            [ ( "width", "180px" )
            , ( "margin-left", "10px" )
            ]
        , onClick (move (SetCurrent index))
        ]
        [ img
            [ src image
            , style [ ( "width", "100%" ) ]
            ]
            []
        ]


px : Float -> String
px value =
    (toString value) ++ "px"
