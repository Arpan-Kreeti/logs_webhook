defmodule LogsWebhookWeb.Router do
  use LogsWebhookWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {LogsWebhookWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LogsWebhookWeb do
    pipe_through [:browser, :auth]

    live "/", LogsLive, :index
  end

  scope "/", LogsWebhookWeb do
    pipe_through :api

    post "/logs/create", LogsController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", LogsWebhookWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: LogsWebhookWeb.Telemetry
    end
  end

  defp auth(conn, _opts) do
    username = "admin" || System.fetch_env!("AUTH_USERNAME")
    password = "password" || System.fetch_env!("AUTH_PASSWORD")
    Plug.BasicAuth.basic_auth(conn, username: username, password: password)
  end
end
