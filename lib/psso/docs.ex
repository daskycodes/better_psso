defmodule Psso.Docs do
  use NimblePublisher,
    build: Psso.Docs.Doc,
    from: "docs/api/v1/*.md",
    as: :docs,
    highlighters: [:makeup_elixir]

  def all_docs, do: @docs
  def doc, do: @docs |> List.first()
end
