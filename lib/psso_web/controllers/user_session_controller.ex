defmodule PssoWeb.UserSessionController do
  use PssoWeb, :controller

  alias PssoWeb.UserAuth

  import Psso.Routes

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"campusid" => campusid, "password" => password} = user_params

    with {:ok, headers, asi} <- Psso.Authentication.login(campusid, password) do
      UserAuth.log_in_user(conn, headers, asi)
    else
      {:error, :unauthorized} ->
        render(conn, "new.html", error_message: "Invalid campusid or password")

      {:error, :psso_error} ->
        render(conn, "new.html",
          error_message:
            "Either the password is wrong or there is something going on at the TH-Köln Server."
        )
    end
  end

  def delete(conn, _params) do
    headers = get_session(conn, :headers)
    HTTPoison.get!(log_out_url(), headers)

    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
