module PhotoGroove exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

urlPrefix = "http://elm-in-action.com/"

initialModel =
    [ { url = "1.jpeg" }
    , { url = "2.jpeg" }
    , { url = "3.jpeg" }
    ]

view model =
    div [class "content"]
        [ h1 [] [text "Photo groove"]
        , div [id "thumbnail"] (List.map viewThumbnail model)
        ]


viewThumbnail thumbnail =
    img [ src ( urlPrefix ++ thumbnail.url ) ] []

main = view initialModel
