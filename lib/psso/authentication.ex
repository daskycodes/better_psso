defmodule Psso.Authentication do
  import Psso.Routes

  def login(campusid, password) do
    credentials = "#{campusid}:#{password}" |> Base.encode64()
    headers = [Authorization: "Basic #{credentials}"]

    with {:ok, response} <- HTTPoison.get(log_in_url(), headers),
         302 <- response.status_code,
         {:ok, headers} <- set_cookie(response) do
      {:ok, headers, get_asi(headers)}
    else
      401 -> {:error, :unauthorized}
      _ -> {:error, :psso_error}
    end
  end

  defp set_cookie(response) do
    try do
      j_session_id =
        response.headers
        |> Enum.filter(fn {key, _} -> String.match?(key, ~r/\Aset-cookie\z/i) end)
        |> List.first()
        |> elem(1)

      {:ok, [Cookie: [j_session_id]]}
    rescue
      ArgumentError -> {:error, :psso_error}
    end
  end

  defp get_asi(headers) do
    HTTPoison.get!(
      base_url(),
      headers,
      set_asi_params()
    )
    |> get_asi_from_response()
  end

  defp get_asi_from_response(response) do
    Floki.parse_document!(response.body)
    |> Floki.find("a.auflistung")
    |> Floki.attribute("href")
    |> List.last()
    |> String.split("=")
    |> List.last()
  end
end
