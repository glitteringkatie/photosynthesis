module PhotoView exposing (..)

import Html exposing (Html, div, text, input, img)
import Html.Attributes exposing (class, type', src)
import Html.Events exposing (onClick)
import Html.App exposing (beginnerProgram)
import List exposing (repeat, map, append, reverse)

-- Dummy Main --

model : Model
model =
  Model examplePhoto "" True

update : Msg -> Model -> Model
update msg model =
  case msg of
    LikePhoto ->
      model
    SubmitComment newComment ->
      { model | newComment = "" }
    CloseModal ->
      model

main : Program Never
main =
  beginnerProgram
    { model = model
    , view = view
    , update = update
    }


-- Model --

type alias Photo =
  { user : String
  , location : String
  , likesCount : Int
  , commentsCount : Int
  , comments : List Comment
  , url : String
  }

examplePhoto : Photo
examplePhoto =
  { user = "Katie"
  , location = "Oregon, United States"
  , likesCount = 42
  , commentsCount = 69
  , comments = repeat 10 exampleComment
  , url = "https://scontent-sea1-1.xx.fbcdn.net/v/t31.0-8/15723801_10211860090922881_8558090155929719618_o.jpg?oh=f48ecf6713e78b1667491897ff0dabad&oe=591F5C9F"
  }

type alias Comment =
  { user : String
  , message : String
  }

exampleComment : Comment
exampleComment =
  { user = "Erwin"
  , message = "You're the best cat mom!"
  }

type alias Model =
  { photo : Photo
  , newComment : String
  , showCloseButton : Bool
  }


-- Messages --

type Msg
  = LikePhoto
  | SubmitComment String
  | CloseModal


-- View --

photo : String -> Html Msg
photo photoUrl =
  img [ class "photo", src photoUrl ] []

sidebar : Photo -> Html Msg
sidebar photo =
  div [ class "sidebar"]
      [ sidebarTop photo.user photo.location
      , sidebarCount photo.likesCount photo.commentsCount
      , sidebarComments photo.commentsCount photo.comments
      ]

sidebarTop : String -> String -> Html Msg
sidebarTop user location =
  div [ class "sidebar-top" ]
      [ div [ class "photo-info"]
            [ div [ class "user" ] [ text user ]
            , div [ class "location" ] [ text location ]
            ]
      , div [ class "photo-actions" ]
            [ followButton , likeButton ]
      ]

followButton : Html Msg
followButton =
  div [ class "follow-button" ]
      [ text "Follow" ]

likeButton : Html Msg
likeButton =
  div [ class "like-button"
      , onClick LikePhoto
      ]
      [ text "Like This Photo" ]

closeButton : Html Msg
closeButton =
  div [ class "close-button", onClick CloseModal ]
      [ text "X" ]

sidebarCount : Int -> Int -> Html Msg
sidebarCount likesCount commentsCount =
  let
    likesCountStr = toString likesCount
    commentsCountStr = toString commentsCount
  in
    div [] [ text likesCountStr
           , text " likes, "
           , text commentsCountStr
           , text " comments"
           ]

sidebarComments : Int -> List Comment -> Html Msg
sidebarComments commentsCount comments =
  let
    pageSize = 10
    pages = commentsCount // pageSize
    commentsList = comments
                 |> map displayComment
                 |> div [ class "comments-list" ]
    loadMoreItems = div [ class "load-more-comments" ]
                        [ text "Load More Comments" ]
    container =
      if pages == 1
         then [ commentsList ]
         else [ commentsList, loadMoreItems ]
  in
    div [ class "comments-container" ] container

displayComment : Comment -> Html Msg
displayComment { user, message } =
  div [ class "comment" ]
      [ div [ class "user" ] [ text user ]
      , div [ class "message" ] [ text message ]
      ]

view : Model -> Html Msg
view model =
  let
    photoHtml = photo model.photo.url
    sidebarHtml = sidebar model.photo
    html =
      case model.showCloseButton of
        True -> [ photoHtml, sidebarHtml, closeButton ]
        False -> [ photoHtml, sidebarHtml ]
  in
    div [ class "photo-view" ] html
