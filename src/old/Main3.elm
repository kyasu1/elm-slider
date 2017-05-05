module Main3 exposing (..)

import Slider3 as Slider exposing (view, prev, next)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import List.Zipper as Zipper exposing (Zipper)


imageList : List String
imageList =
    [ "https://auctions.c.yimg.jp/images.auctions.yahoo.co.jp/image/dr141/auc0302/users/8/4/3/8/pawnshopiko-imgbatch_1487215837/600x600-2017021300045.jpg"
    , "https://auctions.c.yimg.jp/images.auctions.yahoo.co.jp/image/dr141/auc0302/users/8/4/3/8/pawnshopiko-imgbatch_1487215837/600x600-2017021300046.jpg"
    , "https://auctions.c.yimg.jp/images.auctions.yahoo.co.jp/image/dr141/auc0302/users/8/4/3/8/pawnshopiko-imgbatch_1487215837/600x600-2017021300047.jpg"
    , "https://auctions.c.yimg.jp/images.auctions.yahoo.co.jp/image/dr141/auc0302/users/8/4/3/8/pawnshopiko-imgbatch_1487215837/600x600-2017021300048.jpg"
    , "https://auctions.c.yimg.jp/images.auctions.yahoo.co.jp/image/dr141/auc0302/users/8/4/3/8/pawnshopiko-imgbatch_1487215837/600x600-2017021300049.jpg"
    , "https://auctions.c.yimg.jp/images.auctions.yahoo.co.jp/image/dr141/auc0302/users/8/4/3/8/pawnshopiko-imgbatch_1487215837/600x600-2017021600001.jpg"
    ]


type alias Model =
    { sliderState : Slider.State
    , images : Zipper String
    }


initialModel : Model
initialModel =
    { sliderState = Slider.initialState
    , images = Zipper.fromList imageList |> Zipper.withDefault ""
    }


type Msg
    = NoOp
    | SliderMsg Slider.Msg
    | EraseData
    | AppendData


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        SliderMsg sliderMsg ->
            let
                ( newSlider, cmd, images ) =
                    Slider.update model.images sliderMsg model.sliderState
            in
                ( { model | sliderState = newSlider, images = images }, Cmd.map SliderMsg cmd )

        EraseData ->
            ( { model | images = Zipper.mapAfter (\_ -> []) model.images }, Cmd.none )

        AppendData ->
            ( { model | images = Zipper.mapAfter (\list -> list ++ imageList) model.images }, Cmd.none )


config : Slider.Config
config =
    Slider.config { width = 600, height = 600 }


view : Model -> Html Msg
view { sliderState, images } =
    div []
        [ div [ class "carousel slide" ]
            [ div [ class "carousel-inner" ]
                [ Slider.view config sliderState images
                ]
            , a [ class "left carousel-control", onClick (prev ( 1000, 0 )) ]
                [ span [ class "glyphicon glyphicon-chevron-left" ] []
                , span [ class "sr-only" ] [ text "Previous" ]
                ]
            , a [ class "right carousel-control", onClick (next ( 1000, 0 )) ]
                [ span [ class "glyphicon glyphicon-chevron-right" ] []
                , span [ class "sr-only" ] [ text "Next" ]
                ]
            ]
            |> Html.map SliderMsg
        , button [ onClick EraseData ] [ text "ERASE" ]
        , button [ onClick AppendData ] [ text "Append" ]
        ]


main : Program Never Model Msg
main =
    Html.program
        { init = ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \model -> Sub.map SliderMsg (Slider.subscriptions model.sliderState)
        }
