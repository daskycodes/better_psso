defmodule PssoWeb.Router do
  use PssoWeb, :router

  import PssoWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PssoWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PssoWeb do
    pipe_through [:browser]

    live "/", PageLive, :index

    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    delete "/users/log_out", UserSessionController, :delete
  end

  scope "/", PssoWeb do
    pipe_through [:browser, :require_authenticated_user]

    live "/grading", GradingLive, :index
    live "/certificates", CertificatesLive, :index
    get "/certificates/:type/:id", CertificateDownloadController, :download_certificate
  end

  # Other scopes may use custom stacks.
  # scope "/api", PssoWeb do
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
      live_dashboard "/dashboard", metrics: PssoWeb.Telemetry
    end
  end
end
