use Kitto.Job.DSL

defmodule Kitto.Jobs.Chuck do
  @endpoint "http://api.icndb.com"

  def fetch_joke do
    HTTPoison.get!("#{@endpoint}/jokes/random", [], [ ssl: [{:versions, [:'tlsv1.2']}] ]).body
    |> Poison.decode!
    |> parse_response
    |> HtmlEntities.decode
  end

  defp parse_response(%{"type" => "success", "value" => %{"id" => _, "joke" => joke, "categories" => _}}), do: joke
  defp parse_response(_), do: "Something went wrong 😢"
end

HTTPoison.start

job :chuck, every: {5, :seconds} do
  broadcast! :chuck, %{text: Kitto.Jobs.Chuck.fetch_joke}
end
