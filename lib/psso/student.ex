defmodule Psso.Student do
  import Psso.Routes

  @options [ssl: [{:versions, [:"tlsv1.2"]}], recv_timeout: 1800]
  def get_profile_table(headers, asi) do
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
      "<div class='alert text-red-700 bg-red-100' role='alert'>Your session has expired. Please log out and log in again.</div>"
    else
      table
      |> Floki.raw_html()
    end
  end
end
