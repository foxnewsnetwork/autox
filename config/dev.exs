use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :autox, Autox.Endpoint,
  http: [port: 4001],
  debug_errors: true,
  code_reloader: true,
  cache_static_lookup: false,
  check_origin: false,
  watchers: []

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development.
# Do not configure such in production as keeping
# and calculating stacktraces is usually expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :autox, Autox.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "ia",
  password: "1234567",
  database: "autox_dev",
  hostname: "localhost",
  pool_size: 10

config :autox, Autox.Defaults,
  repo: Autox.Repo,
  session_header: "autox-remember-token",
  user_class: Autox.User,
  session_class: Autox.Session