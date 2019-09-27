defmodule TestIsolationWeb.Router do
  use TestIsolationWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TestIsolationWeb do
    pipe_through :api
  end
end
