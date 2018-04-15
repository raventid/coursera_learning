-- This program is modified version of:
-- https://guide.elm-lang.org/architecture/effects/random.html

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Random

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }




-- MODEL

type alias Model =
  { dieFace : Int
  }


init : (Model, Cmd Msg)
init =
  (Model 1, Cmd.none)




-- UPDATE

type Msg
  = Roll
  | RollOutbound
  | NewFace Int

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll ->
      (model, Random.generate NewFace (Random.int 1 6))

    RollOutbound ->
      (model, Random.generate NewFace (Random.int 1 20))

    NewFace newFace ->
      (Model newFace, Cmd.none)




-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none




-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ h1 [] [
        img [src (buildImgSrc (toString model.dieFace))] []
      ]
    , button [ onClick Roll ] [ text "Roll" ]
    , button [ onClick RollOutbound] [ text "RollOutbound" ]
    ]

buildImgSrc : String -> String
buildImgSrc dieFace = "https://www.wpclipart.com/recreation/games/dice/die_face_" ++ dieFace ++ ".png"
