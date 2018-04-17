module PhotoGroove exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

urlPrefix = "http://elm-in-action.com/"

initialModel =
    {
      photos = [ { url = "1.jpeg" }
               , { url = "2.jpeg" }
               , { url = "3.jpeg" }
               ]
    , selectedUrl = "1.jpeg"
    }

view model =
    div [class "content"]
        [ h1 [] [text "Photo groove"]
        , div
            [id "thumbnail"]
            (List.map (\photo -> viewThumbnail model.selectedUrl photo) model.photos)
        , img
            [class "large"
            , src (urlPrefix ++ "large/" ++ model.selectedUrl)
            ]
            []
        ]


viewThumbnail selectedUrl thumbnail =
     img
         [ src ( urlPrefix ++ thumbnail.url )
         , classList [ ( "selected", selectedUrl == thumbnail.url ) ]
         ]
         []


main = view initialModel
