module Main exposing (..)

import Css
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (onClick)
import Slider as Slider exposing (view)


imageList : List String
imageList =
    [ "assets/images/1200x1200-2018021500052.jpg"
    , "assets/images/1200x1200-2018021500053.jpg"
    , "assets/images/1200x1200-2018021500054.jpg"
    , "assets/images/1200x1200-2018021500055.jpg"
    , "assets/images/1200x1200-2018021500056.jpg"
    , "assets/images/1200x1200-2018021500057.jpg"
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
    div
        [ css
            [ Css.displayFlex
            , Css.flexDirection Css.column
            , Css.justifyContent Css.center
            , Css.alignItems Css.center
            ]
        ]
        [ div [ css [ Css.maxWidth (Css.px 600) ] ]
            [ Slider.view config slider imageList
            ]
        ]


main : Program Never Model Msg
main =
    Html.program
        { init = ( initialModel, Cmd.none )
        , view = view >> toUnstyled
        , update = update
        , subscriptions = \_ -> Sub.none
        }
