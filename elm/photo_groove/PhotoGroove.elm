module PhotoGroove exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Http
import Array exposing (Array)
import Random
import Html.Attributes exposing (id, class, classList, src, name, type_, title)
import Json.Decode exposing (string, int, list, Decoder)
import Json.Decode.Pipeline exposing (decode, required, optional)

urlPrefix : String
urlPrefix = "http://elm-in-action.com/"


pickExtension : String
pickExtension = ".jpeg"

type alias Photo =
    { url : String
    , size : Int
    , title : String
    }

type alias Model =
    { photos : List Photo
    , selectedUrl : Maybe String
    , loadingError : Maybe String
    , chosenSize : ThumbnailSize
    }

type Msg =
      SelectByUrl String
    | SurpriseMe
    | SetSize ThumbnailSize
    | SelectByIndex Int
    | LoadPhotos (Result Http.Error (List Photo))

type ThumbnailSize =
      Small
    | Medium
    | Large

initialModel : Model
initialModel =
    {
      photos = []
    , selectedUrl = Nothing
    , loadingError = Nothing
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
        , viewLarge model.selectedUrl
        ]

viewOrError : Model -> Html Msg
viewOrError model =
    case model.loadingError of
        Nothing ->
            view model
        Just errorMsg ->
            div [class "error-message"]
                [ h1 [] [text "Photo groove"]
                , p [] [text errorMsg]
                ]


viewLarge : Maybe String -> Html Msg
viewLarge maybeUrl =
    case maybeUrl of
        Nothing ->
            text ""
        Just url ->
            img [ class "large", src ( urlPrefix ++ "large/" ++ url ) ] []

viewThumbnail : Maybe String -> Photo -> Html Msg
viewThumbnail selectedUrl thumbnail =
     img
         [ src ( urlPrefix ++ thumbnail.url )
         , title (thumbnail.title ++ " [" ++ toString thumbnail.size ++ " KB]")
         , classList [ ( "selected", selectedUrl == Just thumbnail.url ) ]
         , onClick ( SelectByUrl thumbnail.url )
         ]
         []

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectByUrl url ->
            ( { model | selectedUrl = Just url }, Cmd.none )
        SelectByIndex index ->
            let
                newSelectedUrl : Maybe String
                newSelectedUrl =
                    model.photos
                        |> Array.fromList
                        |> Array.get index
                        |> Maybe.map .url
            in
                ( { model | selectedUrl = newSelectedUrl }, Cmd.none )
        SurpriseMe ->
            let
                randomPhotoPicker =
                    Random.int 0 (List.length model.photos - 1)
            in
                ( model, Random.generate SelectByIndex randomPhotoPicker )
        SetSize size ->
            ( { model | chosenSize = size }, Cmd.none )
        LoadPhotos (Ok photos) ->
                ( { model | photos = photos, selectedUrl = Maybe.map .url (List.head photos) }, Cmd.none )
        LoadPhotos (Err text) ->
            ( { model | loadingError = Just ("Error! (Try turning it off and on again.)" ++ toString text) }, Cmd.none)

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

photoDecoder : Decoder Photo
photoDecoder =
    decode Photo
        |> required "url" string
        |> required "size" int
        |> optional "title" string "(untitled)"

getPhotoUrl : Int -> Maybe String
getPhotoUrl index =
    case Array.get index photoArray of
        Just photo ->
            Just photo.url
        Nothing ->
            Nothing

initialCmd : Cmd Msg
initialCmd =
    list photoDecoder
           |> Http.get "http://elm-in-action.com/photos/list.json"
           |> Http.send LoadPhotos

main : Program Never Model Msg
main = Html.program
       {
         init = ( initialModel, initialCmd )
       , view = viewOrError
       , update = update
       , subscriptions = ( \_ -> Sub.none )
       }
