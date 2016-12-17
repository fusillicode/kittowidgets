use Kitto.Job.DSL

defmodule Kitto.Jobs.Chuck do
  @endpoints [
    "http://api.icndb.com/jokes/random",
    "https://api.chucknorris.io/jokes/random"
  ]
  @average_words_read_per_minute 200

  def fetch_joke do
    @endpoints
    |> Enum.random
    |> HTTPoison.get!([], [ ssl: [{:versions, [:'tlsv1.2']}] ])
    |> Map.get(:body)
    |> Poison.decode!
    |> parse_response
    |> HtmlEntities.decode
  end

  def wait_to_read(joke) do
    joke |> seconds_needed_to_read |> :timer.sleep
  end

  defp parse_response(%{"type" => "success", "value" => %{"id" => _, "joke" => joke, "categories" => _}}), do: joke
  defp parse_response(%{"icon_url" => _, "id" => _, "url" => _, "value" => joke}), do: joke
  defp parse_response(_), do: "Something went wrong 😢"

  defp seconds_needed_to_read(joke) when is_bitstring(joke), do: joke |> String.split |> seconds_needed_to_read
  defp seconds_needed_to_read(joke) when is_list(joke), do: joke |> length |> seconds_needed_to_read
  defp seconds_needed_to_read(joke) when is_number(joke), do: (joke * 60 / @average_words_read_per_minute) * 1000 |> round
end

HTTPoison.start

job :chuck, every: {5, :seconds} do
  joke = Kitto.Jobs.Chuck.fetch_joke
  broadcast! :chuck, %{text: joke}
  Kitto.Jobs.Chuck.wait_to_read joke
end
