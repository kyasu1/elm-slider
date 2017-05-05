module Main4 exposing (..)

import Slider4 as Slider exposing (view, Direction(..))
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
    | EraseData
    | AppendData
    | NextClick
    | PrevClick
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

        EraseData ->
            let
                newSlider =
                    { slider | images = Zipper.mapAfter (\_ -> []) model.slider.images }
            in
                ( { model | slider = newSlider }, Cmd.none )

        AppendData ->
            let
                newSlider =
                    { slider | images = Zipper.mapAfter (\list -> list ++ imageList) model.slider.images }
            in
                ( { model | slider = newSlider }, Cmd.none )

        NextClick ->
            case Zipper.next slider.images of
                Just images ->
                    let
                        ( transition, cmd ) =
                            Transit.start TransitMsg ResetDirection ( 500, 0 ) { transition = slider.transition }

                        newSlider =
                            { slider
                                | images = images
                                , direction = Just LeftToRight
                                , transition = transition.transition
                            }
                    in
                        ( { model | slider = newSlider }, cmd )

                Nothing ->
                    ( model, Cmd.none )

        PrevClick ->
            case Zipper.previous slider.images of
                Just images ->
                    let
                        ( transition, cmd ) =
                            Transit.start TransitMsg ResetDirection ( 500, 0 ) { transition = slider.transition }

                        newSlider =
                            { slider
                                | images = images
                                , direction = Just RightToLeft
                                , transition = transition.transition
                            }
                    in
                        ( { model | slider = newSlider }, cmd )

                Nothing ->
                    ( model, Cmd.none )

        TransitMsg msg ->
            let
                ( newSlider, cmd ) =
                    Transit.tick TransitMsg msg slider
            in
                ( { model | slider = newSlider }, cmd )


subscriptions : Model -> Sub Msg
subscriptions model =
    Transit.subscriptions TransitMsg model.slider


config : Slider.Config
config =
    Slider.config { width = 600, height = 600 }


view : Model -> Html Msg
view { slider } =
    div []
        [ div [ class "carousel slide" ]
            [ div [ class "carousel-inner" ]
                [ Slider.view config slider
                ]
            , a [ class "left carousel-control", onClick PrevClick ]
                [ span [ class "glyphicon glyphicon-chevron-left" ] []
                , span [ class "sr-only" ] [ text "Previous" ]
                ]
            , a [ class "right carousel-control", onClick NextClick ]
                [ span [ class "glyphicon glyphicon-chevron-right" ] []
                , span [ class "sr-only" ] [ text "Next" ]
                ]
            ]
        , button [ onClick EraseData ] [ text "ERASE" ]
        , button [ onClick AppendData ] [ text "Append" ]
        ]


main : Program Never Model Msg
main =
    Html.program
        { init = ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
