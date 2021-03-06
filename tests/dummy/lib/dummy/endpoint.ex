defmodule Dummy.Endpoint do
  use Phoenix.Endpoint, otp_app: :dummy

  socket "/socket", Dummy.UserSocket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/", from: :dummy, gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Autox.InsecureSessionPlug,
    store: :cookie,
    key: "_dummy_key",
    signing_salt: "tXVNJL9p",
    max_age: 26_280_000 # 10 months

  plug CORSPlug,
    headers: CORSPlug.defaults[:headers] ++ ["_dummy_key"],
    expose: ["_dummy_key"]

  plug Dummy.Router
end
