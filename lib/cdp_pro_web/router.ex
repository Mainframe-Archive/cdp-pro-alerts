defmodule CdpProWeb.Router do
  use CdpProWeb, :router

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

  scope "/", CdpProWeb do
    pipe_through :api

    post "/subscriptions", SubscriptionController, :create
  end
  scope "/", CdpProWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/subscriptions", SubscriptionController
  end

end
