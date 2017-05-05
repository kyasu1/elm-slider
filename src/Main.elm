module Main exposing (..)

import Slider as Slider exposing (view)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


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
    { slider = Slider.initialState
    }


type Msg
    = Move Slider.Action


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ slider } as model) =
    case msg of
        Move direction ->
            ( { model | slider = Slider.moveImage direction model.slider }, Cmd.none )


view : Model -> Html Msg
view { slider } =
    let
        config =
            Slider.config { move = Move }
    in
        Slider.view config slider imageList


main : Program Never Model Msg
main =
    Html.program
        { init = ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
