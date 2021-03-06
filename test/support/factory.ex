defmodule Review.Factory do
  use ExMachina.Ecto, repo: Review.Repo

  alias Review.{Commit, Author, Comment}

  def author_factory do
    %Author{ name: "Joe", email: "joe@example.com", username: "joe" }
  end

  def commit_factory do
    %Commit{ sha: "2107c5d7b290c0ca294d4d70029e87b599bc9152", payload: "only-used-by-the-ruby-app-but-can-not-be-null", json_payload: commit_payload(), author: build(:author) }
  end

  def comment_factory do
    # TODO: add payload as json_payload when the field exists
    %Comment{ github_id: -1, commit_sha: "2107c5d7b290c0ca294d4d70029e87b599bc9152", payload: "only-used-by-the-ruby-app-but-can-not-be-null", author: build(:author), json_payload: comment_payload() }
  end

  def comment_payload do
    File.read!("test/fixtures/comment_payload.json")
  end

  def push_payload do
    File.read!("test/fixtures/push_payload.json")
  end

  def pair_commit_push_payload do
    File.read!("test/fixtures/pair_commit_push_payload.json")
  end

  # This payload is actually the commit payload + repository from the push payload, but that is
  # what we save in the database.
  defp commit_payload do
    File.read!("test/fixtures/commit_payload.json")
  end
end
