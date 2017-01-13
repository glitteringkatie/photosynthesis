module Main exposing (..)

import PhotoView exposing (Photo, Comment)
import Html.App exposing (beginnerProgram)
import Html exposing (Html, div, text, img, span)
import Html.Attributes exposing (class, src, width, height)
import Html.Events exposing (onClick)
import List exposing (map, take, length, drop, repeat, append)

type alias Model =
  { photo : Photo
  , newComment : String
  , showCloseButton : Bool
  }

model =
  Model PhotoView.examplePhoto "" True

update : PhotoView.Msg -> Model -> Model
update msg model =
  case msg of
    PhotoView.LikePhoto ->
      model
    PhotoView.SubmitComment newComment ->
      { model | newComment = "" }
    PhotoView.CloseModal ->
      model

main =
  beginnerProgram
    { model = model
    , view = PhotoView.view
    , update = update
    }
