module CommitList where

import CommitList.Types exposing (..)
import CommitList.View exposing (view)
import CommitList.Update exposing (update)

import Html exposing (..)
import String


---- API to the outside world (javascript/server) ----

--- receives initial data
port initialCommits : List Commit
port environment : String

-- receives updated commit data
port updatedCommit : Signal Commit

-- publishes events like [ "StartReview", "12" ]
port outgoingCommands : Signal (List String)
port outgoingCommands =
  inbox.signal
  |> Signal.map (\action -> action |> toString |> String.split(" "))
  |> Signal.filter isOutgoing []

isOutgoing event =
  List.member (eventName event) [ "StartReview", "AbandonReview" ]

eventName event =
  event
  |> List.head
  |> Maybe.withDefault ""


---- current state and action collection ----

main : Signal Html
main =
  Signal.map (view inbox.address) model

model : Signal Model
model =
  Signal.foldp update initialModel actions

initialModel : Model
initialModel =
  {
    commits = initialCommits
  , lastClickedCommitId = 0
  , environment = environment
  }

actions : Signal Action
actions =
  Signal.merge inbox.signal updatedCommitSignal

updatedCommitSignal =
  updatedCommit
  |> Signal.map UpdatedCommit

inbox : Signal.Mailbox Action
inbox =
  Signal.mailbox NoOp
