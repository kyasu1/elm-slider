module Main6 exposing (..)

import Slider6 as Slider exposing (view, Direction(..))
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import List.Zipper as Zipper exposing (Zipper)
import Transit


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
    { slider : Slider.State
    }


initialModel : Model
initialModel =
    { slider = Slider.initialState imageList
    }


type Msg
    = ResetDirection
    | AppendData (List String)
    | Move Direction
    | TransitMsg (Transit.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ slider } as model) =
    case msg of
        ResetDirection ->
            let
                newSlider =
                    { slider | direction = Nothing }
            in
                ( { model | slider = newSlider }, Cmd.none )

        AppendData list ->
            let
                newSlider =
                    { slider | images = Zipper.mapAfter (\original -> original ++ list) model.slider.images }
            in
                ( { model | slider = newSlider }, Cmd.none )

        Move direction ->
            let
                ( transition, cmd ) =
                    Transit.start TransitMsg ResetDirection ( 500, 0 ) { transition = slider.transition }

                slider =
                    Slider.moveImage direction model.slider

                newSlider =
                    { slider | transition = transition.transition }
            in
                ( { model | slider = newSlider }, cmd )

        TransitMsg msg ->
            let
                ( newSlider, cmd ) =
                    Transit.tick TransitMsg msg slider
            in
                ( { model | slider = newSlider }, cmd )


subscriptions : Model -> Sub Msg
subscriptions model =
    Transit.subscriptions TransitMsg model.slider


config =
    Slider.config { width = 600, height = 600, move = Move }


view : Model -> Html Msg
view { slider } =
    div []
        [ Slider.view config slider
        ]


main : Program Never Model Msg
main =
    Html.program
        { init = ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
