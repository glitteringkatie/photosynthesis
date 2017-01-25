module Main exposing (..)

import PhotoView exposing (Photo, Comment)
import Html.App exposing (beginnerProgram)
import Html exposing (Html, div, text, img, span)
import Html.Attributes exposing (class, src, width, height)
import Html.Events exposing (onClick)
import List exposing (map, take, length, drop, repeat, append)


-- Model --

type alias Model =
  { name : String
  , photoCount : Int
  , photos : List Photo
  , photoOpened : Maybe Photo
  , newComment : String
  }

model : Model
model =
  { name = "#elm"
  , photoCount = 123456789
  , photos = repeat 8 PhotoView.examplePhoto
  , photoOpened = Nothing
  , newComment = ""
  }


-- View --

photoGrid : List Photo -> Html Msg
photoGrid photos =
  photos
    |> map photoItem
    |> div [ class "photo-grid" ]

photoItem : Photo -> Html Msg
photoItem photo =
  div [ class "photo" ]
      [ img [ src photo.url
            , width 300
            , height 300
            , onClick (OpenPhoto photo)
            ]
            []
      ]

profileInfo : String -> Int -> Html Msg
profileInfo name photoCount =
  div [ class "profile-info" ]
      [ div [ class "name"]
            [ text name ]
      , div [ class "count" ]
            [ span [ class "value" ]
                   [ photoCount |> toString |> text ]
            , text " posts"
            ]
      ]

photoView : String -> Photo -> Html Msg
photoView newComment photoOpened =
  let
    model = { photo = photoOpened
            , newComment = newComment
            , showCloseButton = True
            }
  in
    model
      |> PhotoView.view
      |> Html.App.map (\_ -> ClosePhoto)

view : Model -> Html Msg
view model =
  let
    body = [ profileInfo model.name model.photoCount
           , photoGrid model.photos
           ]
  in
    case model.photoOpened of
      Nothing ->
        div [] body
      Just photoOpened ->
        photoOpened
          |> photoView model.newComment
          |> repeat 1
          |> append body
          |> div []


-- Message --

type Msg
  = OpenPhoto Photo
  | ClosePhoto

-- Update --

update : Msg -> Model -> Model
update msg model =
  case msg of
    OpenPhoto photo ->
      { model | photoOpened = Just photo }
    ClosePhoto ->
      { model | photoOpened = Nothing }

main : Program Never
main =
  beginnerProgram
    { model = model
    , view = view
    , update = update
    }
