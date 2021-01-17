defmodule Psso.Psso do
  import Psso.Psso.Routes

  @options [ssl: [{:versions, [:"tlsv1.2"]}], recv_timeout: 1800]

  def login(campusid, password) do
    credentials = "#{campusid}:#{password}" |> Base.encode64()
    headers = [Authorization: "Basic #{credentials}"]

    with {:ok, response} <- HTTPoison.get(log_in_url(), headers),
         302 <- response.status_code do
      headers = set_cookie(response)
      {:ok, headers, set_asi(headers)}
    else
      401 -> {:error, :unauthorized}
      _ -> {:error, :internal_server_error}
    end
  end

  def set_cookie(response) do
    j_session_id =
      response.headers
      |> Enum.filter(fn {key, _} -> String.match?(key, ~r/\Aset-cookie\z/i) end)
      |> List.first()
      |> elem(1)

    [Cookie: [j_session_id]]
  end

  def set_asi(headers) do
    HTTPoison.get!(
      base_url(),
      headers,
      set_asi_params()
    )
    |> get_asi_from_response()
  end

  def get_asi_from_response(response) do
    Floki.parse_document!(response.body)
    |> Floki.find("a.auflistung")
    |> Floki.attribute("href")
    |> List.last()
    |> String.split("=")
    |> List.last()
  end

  def grading_table(headers, asi) do
    {:ok, response} =
      HTTPoison.get(
        base_url(),
        headers,
        Keyword.merge(@options, grading_params(asi))
      )

    table =
      Floki.parse_document!(response.body)
      |> Floki.find("table")
      |> List.last()

    if is_nil(table) do
      "<h2>Your session has expired. Please log out and log in again</h2>"
    else
      table
      |> Floki.raw_html()
    end
  end

  def student_table(headers, asi) do
    {:ok, response} =
      HTTPoison.get(
        base_url(),
        headers,
        Keyword.merge(@options, grading_params(asi))
      )

    table =
      Floki.parse_document!(response.body)
      |> Floki.find("table")
      |> Floki.filter_out("caption")
      |> List.first()

    if is_nil(table) do
      "<h2>Your session has expired. Please log out and log in again</h2>"
    else
      table
      |> Floki.raw_html()
    end
  end

  def certificates_table(headers, _asi) do
    {:ok, response} =
      HTTPoison.get(base_url(), headers, Keyword.merge(@options, certificates_params()))

    table =
      Floki.parse_document!(response.body)
      |> Floki.find_and_update("td a", &replace_certificate_links/1)
      |> Floki.find("table.mod")

    if Enum.empty?(table) do
      "<h2>Your session has expired. Please log out and log in again</h2>"
    else
      table
      |> Floki.raw_html()
    end
  end

  defp replace_certificate_links({"a", [{"href", href}]}) do
    {"a",
     [
       {"href",
        String.replace(
          href,
          "https://psso.th-koeln.de/qisserver/rds?state=verpublish&status=transform&vmfile=no&moduleCall=Report&publishSubDir=qissosreports&publishConfFile=",
          "/certificates/"
        )
        |> String.replace("&publishid=", "/")}
     ]}
  end

  defp replace_certificate_links(other), do: other
end
