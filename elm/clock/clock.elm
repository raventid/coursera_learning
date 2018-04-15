-- Read more about this program in the official Elm guide:
-- https://guide.elm-lang.org/architecture/effects/time.html
-- Customized by raventid


import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)
import Debug exposing (log)



main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }




-- MODEL

type alias Model = Time


init : (Model, Cmd Msg)
init =
  (0, Cmd.none)




-- UPDATE

type Msg
  = Tick Time


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      (newTime, Cmd.none)




-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every second Tick




-- VIEW

view : Model -> Html Msg
view model =
  let
    -- Seconds
    angle =
      turns (Time.inMinutes model)

    w = (log (toString (Time.inMinutes model)))

    handX =
      toString (50 + 40 * cos angle)

    handY =
      toString (50 + 40 * sin angle)

    -- Minutes.
    angleMinute =
      turns (Time.inHours model)

    minuteHandX =
        toString (50 + 35 * cos angleMinute)

    minuteHandY =
        toString (50 + 35 * sin angleMinute)

    -- Hours.
    angleHour =
        turns ((Time.inHours model) / 60)

    hourHandX =
        toString (50 + 25 * cos angleHour)

    hourHandY =
        toString (50 + 25 * sin angleHour)
  in
    svg [ viewBox "0 0 100 100", width "300px" ]
      [ circle [ cx "50", cy "50", r "45", fill "#0B79CE" ] []
      , line [ x1 "50", y1 "50", x2 handX, y2 handY, stroke "#023963" ] []
      , line [ x1 "50", y1 "50", x2 minuteHandX, y2 minuteHandY, stroke "#53f442"] []
      , line [ x1 "50", y1 "50", x2 hourHandX, y2 hourHandY, stroke "#5b3791"] []
      ]
