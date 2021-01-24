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

    get "/docs", DocumentationController, :doc

    get "/log_in", UserSessionController, :new
    post "/log_in", UserSessionController, :create
    delete "/log_out", UserSessionController, :delete
  end

  scope "/", PssoWeb do
    pipe_through [:browser, :require_authenticated_user]

    live "/gradings", GradingLive, :index
    live "/certificates", CertificatesLive, :index
    get "/certificates/:type/:id", CertificateDownloadController, :download_certificate
  end

  scope "/api/v1", PssoWeb do
    pipe_through [:api, :basic_auth]

    get "/gradings", Api.V1.GradingController, :index

    get "/certificates", Api.V1.CertificateController, :index
    get "/certificates/:type/:id", Api.V1.CertificateController, :download
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

  defp basic_auth(conn, _opts) do
    with {campusid, password} <- Plug.BasicAuth.parse_basic_auth(conn),
         {:ok, headers, asi} <- Psso.Authentication.login(campusid, password) do
      conn
      |> assign(:headers, headers)
      |> assign(:asi, asi)
    else
      {:error, message} ->
        conn |> put_status(:unauthorized) |> json(%{error: message}) |> halt()

      _ ->
        conn |> put_status(:unauthorized) |> json(%{error: "Unauthorized"}) |> halt()
    end
  end
end
