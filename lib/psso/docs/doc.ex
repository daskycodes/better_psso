defmodule Psso.Docs.Doc do
  @enforce_keys [:id, :author, :title, :description, :body]
  defstruct [:id, :author, :title, :body, :description]

  def build(_filename, attrs, body) do
    struct!(__MODULE__, [id: "docs", body: body] ++ Map.to_list(attrs))
  end
end
