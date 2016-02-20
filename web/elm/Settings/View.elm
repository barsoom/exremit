module Settings.View (view) where

import Html exposing (div, span, form, p, label, text, input, Html, Attribute)
import Html.Attributes exposing (class, for, id, value, property, name)
import Html.Events exposing (on, targetValue)
import String.Interpolate exposing (interpolate)
import Json.Encode
import Signal exposing (Address)
import String

import Settings.Types exposing (..)

view address model =
  if not model.initialized then
    div [] []
  else
    div [ class "settings-wrapper" ] [
      form [] [
        -- type="email" causes "bouncing" of .please-provide-details
        -- because "foo@bar." is not considered a real value.
        textField {
          id = "settings-email"
        , name = "email"
        , label = "Your email:"
        , value = model.settings.email
        , onInput = (onInput address UpdateEmail)
      }
      , emailHelpText

      , textField {
        id = "settings-name"
      , name = "name"
      , label = "Your name:"
      , value = model.settings.name
      , onInput = (onInput address UpdateName)
      }
    ]

    , helpText [
        p [ innerHtml "Determines <em>your</em> commits and comments by substring." ] []
      , p [] [
          span [ class "test-usage-explanation" ] [ text (usageExample model) ]
        ]
      ]
    ]

-- borrowed from https://online.pragmaticstudio.com/courses/elm/steps/36
onInput : Address a -> (String -> a) -> Attribute
onInput address f =
  on "input" targetValue (\v -> Signal.message address (f v))

emailHelpText =
  helpText [
    text "Uniquely identifies you as a reviewer. Used for"
  --, img [ class "settings-gravatar" ] # TODO: display gavatar and only when an email exists
  , text " your Gravatar."
  ]

textField : Field -> Html
textField field =
  p [] [
    label [ for field.id ] [ text field.label ]
  , text " "

  , input [ id field.id, name field.name, value field.value, field.onInput ] []
  ]

usageExample model =
  if String.isEmpty(model.settings.name) then
    interpolate """If your name is "{0}", a commit authored e.g. by "{0}" or by "Ada Lovelace and {0}" will be considered yours."""  [ model.exampleAuthor ]
  else
    interpolate """A commit authored e.g. by "{0}" or by "Ada Lovelace and {0}" will be considered yours."""  [ model.settings.name ]

innerHtml htmlString =
  property "innerHTML" (Json.Encode.string htmlString)

helpText =
  p [ class "help-text" ]