defmodule Psso.Certificates do
  import Psso.Routes

  @options [ssl: [{:versions, [:"tlsv1.2"]}], recv_timeout: 1800]

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
