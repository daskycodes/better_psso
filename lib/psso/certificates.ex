defmodule Psso.Certificates do
  import Psso.Routes

  @options [ssl: [{:versions, [:"tlsv1.2"]}], recv_timeout: 1800]

  def list_certificates(headers, _asi) do
    {:ok, response} =
      HTTPoison.get(base_url(), headers, Keyword.merge(@options, certificates_params()))

    document =
      Floki.parse_document!(response.body)
      |> Floki.find_and_update("td a", &replace_certificate_links/1)

    links = document |> Floki.find("td a") |> Floki.attribute("href")

    document
    |> Floki.find("table.mod")
    |> Floki.find("td")
    |> Enum.map(&Floki.text/1)
    |> Enum.map(&String.trim/1)
    |> Enum.chunk_every(3)
    |> Enum.with_index()
    |> Enum.map(fn {row, index} ->
      %{
        semester: Enum.at(row, 0),
        links: %{
          studienbescheinigung: Enum.at(links, index + index * 1),
          bafoeg_bescheinigung: Enum.at(links, 1 + index + index * 1)
        }
      }
    end)
  end

  def get_certificates_table(headers, _asi) do
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
