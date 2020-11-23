# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :logs_webhook,
  ecto_repos: [LogsWebhook.Repo]

# Configures the endpoint
config :logs_webhook, LogsWebhookWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "5ebCcdpYdMkEQOoYBsWbVRLsww+U/U2t+OXdCQzGd46FtK90Fi9xFZnf26JRtYnK",
  render_errors: [view: LogsWebhookWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: LogsWebhook.PubSub,
  live_view: [signing_salt: "EzZKUKPv"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configuration for scrivener_html
config :scrivener_html,
  routes_helper: LogsWebhook.Router.Helpers,
  view_style: :bootstrap_v4

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
