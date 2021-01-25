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

  def get_grading_stats(headers, asi) do
    try do
      gradings = list_gradings(headers, asi)

      total_credits =
        Enum.reduce(gradings, 0, fn grading, acc -> String.to_float(grading["Credits"]) + acc end)

      gradings_received = Enum.count(gradings)

      grading_average = caluclate_grading_average(gradings)

      %{
        gradings_received: gradings_received,
        grading_average: grading_average,
        total_credits: total_credits
      }
    rescue
      _ -> %{}
    end
  end

  defp caluclate_grading_average(gradings) do
    gradings = gradings |> Enum.filter(&(&1["Note"] != ""))

    graded_credits =
      Enum.reduce(gradings, 0, fn grading, acc -> String.to_float(grading["Credits"]) + acc end)

    sum =
      Enum.reduce(gradings, 0, fn grading, acc ->
        String.to_float(grading["Credits"]) * String.to_float(grading["Note"]) + acc
      end)

    Float.floor(sum / graded_credits, 2)
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
      "<div class='alert text-red-700 bg-red-100' role='alert'>Your session has expired. Please log out and log in again.</div>"
    else
      table
      |> Floki.raw_html()
    end
  end
end
