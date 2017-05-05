module Main exposing (..)

import Slider2 as Slider exposing (view, prev, next)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


imageList : List String
imageList =
    [ "https://cdn.pixabay.com/photo/2017/04/08/10/23/surfer-2212948_1280.jpg"
    , "https://cdn.pixabay.com/photo/2016/11/18/18/45/beach-1836366_1280.jpg"
    , "https://cdn.pixabay.com/photo/2013/08/17/14/32/sunrise-173392_1280.jpg"
    , "https://cdn.pixabay.com/photo/2016/01/01/19/18/sunrise-1116985_1280.jpg"
    ]


type alias Model =
    { sliderState : Slider.State
    , images : List String
    }


initialModel : Model
initialModel =
    { sliderState = Slider.initialState imageList
    , images = imageList
    }


type Msg
    = NoOp
    | SliderMsg Slider.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        SliderMsg sliderMsg ->
            let
                ( newSlider, cmd ) =
                    Slider.update sliderMsg model.sliderState
            in
                ( { model | sliderState = newSlider }, Cmd.map SliderMsg cmd )


config : Slider.Config
config =
    Slider.config { offsets = ( 600, 600 ) }


view : Model -> Html Msg
view { sliderState, images } =
    div [ class "carousel slide" ]
        [ div
            [ class "carousel-inner"
            , style
                [ ( "overflow", "hidden" )
                , ( "position", "relative" )
                , ( "width", "600px" )
                , ( "height", "320px" )
                , ( "border", "solid 1px #999" )
                ]
            ]
            [ Slider.view config sliderState images ]
        , a [ class "left carousel-control", onClick (prev ( 3000, 3000 )) ]
            [ span [ class "glyphicon glyphicon-chevron-left" ] []
            , span [ class "sr-only" ] [ text "Previous" ]
            ]
        , a [ class "right carousel-control", onClick (next ( 3000, 3000 )) ]
            [ span [ class "glyphicon glyphicon-chevron-right" ] []
            , span [ class "sr-only" ] [ text "Next" ]
            ]
        ]
        |> Html.map SliderMsg


main : Program Never Model Msg
main =
    Html.program
        { init = ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \model -> Sub.map SliderMsg (Slider.subscriptions model.sliderState)
        }
