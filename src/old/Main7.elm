module Main7 exposing (..)

import Slider7 as Slider exposing (view)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Task
import Window


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
    , windowSize : Window.Size
    }


initialModel : Model
initialModel =
    { slider = Slider.initialState
    , windowSize = Window.Size 600 0
    }


type Msg
    = Move Slider.Action
    | Resize Window.Size


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ slider } as model) =
    case msg of
        Move direction ->
            ( { model | slider = Slider.moveImage direction model.slider }, Cmd.none )

        Resize size ->
            ( { model | windowSize = size }, Cmd.none )


view : Model -> Html Msg
view { slider, windowSize } =
    let
        config =
            Slider.config { width = windowSize.width, height = 600, move = Move }
    in
        Slider.view config slider imageList


main : Program Never Model Msg
main =
    Html.program
        { init = ( initialModel, Task.perform Resize Window.size )
        , view = view
        , update = update
        , subscriptions = \_ -> Window.resizes Resize
        }
