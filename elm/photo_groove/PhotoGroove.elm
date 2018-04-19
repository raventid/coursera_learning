module PhotoGroove exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Array exposing (Array)
import Random

urlPrefix : String
urlPrefix = "http://elm-in-action.com/"


pickExtension : String
pickExtension = ".jpeg"

type alias Photo =
    { url : String }

type alias Model =
    { photos : List Photo
    , selectedUrl : String
    , chosenSize : ThumbnailSize
    }

type Msg =
      SelectByUrl String
    | SurpriseMe
    | SetSize ThumbnailSize
    | SelectByIndex Int

type ThumbnailSize =
      Small
    | Medium
    | Large

initialModel : Model
initialModel =
    {
      photos = [ { url = "1.jpeg" } , { url = "2.jpeg" } , { url = "3.jpeg" } ]
    , selectedUrl = "1.jpeg"
    , chosenSize = Medium
    }

view : Model -> Html Msg
view model =
    div [class "content"]
        [ h1 [] [text "Photo groove"]
        , h3 [] [text "Thumbnail size: "]
        , div [id "choose-size"] ( List.map viewSizeChooser [ Small, Medium, Large ] )
        , div
            [id "thumbnails", class ( sizeToString model.chosenSize )]
            (List.map ( viewThumbnail model.selectedUrl ) model.photos)
        , button
            [ onClick SurpriseMe ]
            [ text "Surprise me!" ]
        , img
            [ class "large"
            , src ( urlPrefix ++ "large/" ++ model.selectedUrl )
            ]
            []
        ]

viewThumbnail : String -> Photo -> Html Msg
viewThumbnail selectedUrl thumbnail =
     img
         [ src ( urlPrefix ++ thumbnail.url )
         , classList [ ( "selected", selectedUrl == thumbnail.url ) ]
         , onClick ( SelectByUrl thumbnail.url )
         ]
         []

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectByUrl url ->
            ( { model | selectedUrl = url }, Cmd.none )
        SelectByIndex index ->
            ( { model | selectedUrl = getPhotoUrl index }, Cmd.none )
        SurpriseMe ->
            ( model, Random.generate SelectByIndex randomPhotoPicker )
        SetSize size ->
            ( { model | chosenSize = size }, Cmd.none )

photoArray : Array Photo
photoArray = Array.fromList initialModel.photos

viewSizeChooser : ThumbnailSize -> Html Msg
viewSizeChooser size =
    label
        []
        -- look at another underscore props.
        [ input [ type_ "radio", name "size", onClick ( SetSize size ) ] []
        , text ( sizeToString size )
        ]

sizeToString : ThumbnailSize -> String
sizeToString size =
    case size of
        Small ->
            "small"
        Medium ->
            "med"
        Large ->
            "large"

getPhotoUrl : Int -> String
getPhotoUrl number = ( toString number ) ++ pickExtension

randomPhotoPicker : Random.Generator Int
randomPhotoPicker = Random.int 1 ( Array.length photoArray )

main : Program Never Model Msg
main = Html.program
       {
         init = ( initialModel, Cmd.none )
       , view = view
       , update = update
       , subscriptions = ( \model -> Sub.none )
       }
