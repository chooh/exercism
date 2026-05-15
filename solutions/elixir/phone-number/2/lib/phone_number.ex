defmodule PhoneNumber do
  @doc """
  Remove formatting from a phone number if the given number is valid. Return an error otherwise.
  """
  @spec clean(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def clean(raw) do
    number = String.replace(raw, ~r/[. \(\)\-\+]/, "")

    cond do
      Regex.match?(~r/\D/, number) ->
        {:error, "must contain digits only"}

      String.length(number) < 10 ->
        {:error, "must not be fewer than 10 digits"}

      String.length(number) > 11 ->
        {:error, "must not be greater than 11 digits"}

      String.length(number) == 11 and String.first(number) != "1" ->
        {:error, "11 digits must start with 1"}

      String.at(number, -10) == "0" ->
        {:error, "area code cannot start with zero"}

      String.at(number, -10) == "1" ->
        {:error, "area code cannot start with one"}

      String.at(number, -7) == "0" ->
        {:error, "exchange code cannot start with zero"}

      String.at(number, -7) == "1" ->
        {:error, "exchange code cannot start with one"}

      true ->
        {:ok, String.slice(number, -10..-1)}
    end
  end
end
