module PhotoGroove exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

view model =
    div [class "content"]
        [ h1 [] [text "Photo groove"]
        , div [id "thumbnail"]
            [ img [src "http://elm-in-action.com/1.jpeg"] []
            , img [src "http://elm-in-action.com/2.jpeg"] []
            , img [src "http://elm-in-action.com/3.jpeg"] []]
        ]

main = view "NO MODEL YET"
