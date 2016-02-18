defmodule Exremit.Router do
  use Exremit.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Exremit do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/commits", PageController, :commits
    get "/comments", PageController, :comments
    get "/settings", PageController, :settings
  end

  # Other scopes may use custom stacks.
  # scope "/api", Exremit do
  #   pipe_through :api
  # end
end
