port module PhotoGroove exposing (..)

import Array exposing (Array)
import Random

import Http

import Html exposing (..)
import Html.Attributes exposing (id, class, classList, src, name, type_, title)
import Html.Events exposing (onClick, on)

import Json.Decode exposing (string, int, list, Decoder, at)
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
    , hue : Int
    , ripple : Int
    , noise : Int
    }

port setFilters : FilterOptions -> Cmd msg

type alias FilterOptions =
    { url : String
    , filters : List { name : String, amount : Float}
    }

type Msg =
      SelectByUrl String
    | SurpriseMe
    | SetSize ThumbnailSize
    | SelectByIndex Int
    | LoadPhotos (Result Http.Error (List Photo))
    | SetHue Int
    | SetRipple Int
    | SetNoise Int

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
    , hue = 0
    , ripple = 0
    , noise = 0
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
        , div [class "filters"]
            [ viewFilter SetHue "Hue" model.hue
            , viewFilter SetRipple "Ripple" model.ripple
            , viewFilter SetNoise "Noise" model.noise
            ]
        , viewLarge model.selectedUrl
        ]


viewFilter :(Int -> Msg) -> String -> Int -> Html Msg
viewFilter toMsg name magnitude =
    div [ class "filter-slider" ]
        [ label [] [text name ]
        , paperSlider [Html.Attributes.max "11", onImmediateValueChange toMsg] []
        , label [] [text (toString magnitude) ]
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
            canvas [ id "main-canvas", class "large"] []

viewThumbnail : Maybe String -> Photo -> Html Msg
viewThumbnail selectedUrl thumbnail =
     img
         [ src ( urlPrefix ++ thumbnail.url )
         , title (thumbnail.title ++ " [" ++ toString thumbnail.size ++ " KB]")
         , classList [ ( "selected", selectedUrl == Just thumbnail.url ) ]
         , onClick ( SelectByUrl thumbnail.url )
         ]
         []

applyFilters : Model -> ( Model, Cmd Msg )
applyFilters model =
    case model.selectedUrl of
        Just selectedUrl ->
            let filters =
                    [ {name = "Hue", amount = toFloat model.hue / 11}
                    , {name = "Ripple", amount = toFloat model.ripple / 11}
                    , {name = "Noise", amount = toFloat model.noise / 11}
                    ]
                url = urlPrefix ++ "large/" ++ selectedUrl
            in
                ( model, setFilters { url = url, filters = filters } )
        Nothing ->
            ( model, Cmd.none )

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectByUrl url ->
            applyFilters { model | selectedUrl = Just url }
        SelectByIndex index ->
            let
                newSelectedUrl : Maybe String
                newSelectedUrl =
                    model.photos
                        |> Array.fromList
                        |> Array.get index
                        |> Maybe.map .url
            in
                 applyFilters { model | selectedUrl = newSelectedUrl }
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
        SetHue hue ->
            applyFilters { model | hue = hue }
        SetRipple ripple ->
            applyFilters  { model | ripple = ripple }
        SetNoise noise ->
            applyFilters  { model | noise = noise }

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



-- Integration of paper-sliders BEGIN.

paperSlider : List (Attribute msg) -> List (Html msg) -> Html msg
paperSlider =
    -- All of the functions done like this, i.e. `h1 [] []` is just a `node "h1"`
    node "paper-slider"

onImmediateValueChange : (Int -> msg) -> Attribute msg
onImmediateValueChange toMsg =
    at ["target", "immediateValue"] int
        |> Json.Decode.map toMsg
        |> on "immediate-value-changed"

-- Integration of paper-sliders END.

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
