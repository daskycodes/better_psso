defmodule Psso.Grading do
  import Psso.Routes

  @options [ssl: [{:versions, [:"tlsv1.2"]}], recv_timeout: 1800]
  def list_gradings(headers, asi) do
    {:ok, response} =
      HTTPoison.get(
        base_url(),
        headers,
        Keyword.merge(@options, grading_params(asi))
      )

    document = Floki.parse_document!(response.body)

    course_keys =
      document
      |> Floki.find("table")
      |> List.last()
      |> Floki.find("th")
      |> Enum.map(&Floki.text/1)
      |> Enum.map(&String.trim/1)

    document
    |> Floki.find("table")
    |> List.last()
    |> Floki.filter_out(".qis_konto")
    |> Floki.filter_out(".qis_kontoOnTop")
    |> Floki.find("td")
    |> Enum.map(&Floki.text/1)
    |> Enum.map(&String.trim/1)
    |> Enum.chunk_every(11)
    |> Enum.map(fn row ->
      Map.new(
        Enum.with_index(row)
        |> Enum.map(fn {value, index} -> {Enum.at(course_keys, index), value} end)
      )
    end)
    |> Enum.map(&Map.put(&1, "Fachsemseter", String.first(&1["PNR"])))
  end

  def get_grading_table(headers, asi) do
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
end
