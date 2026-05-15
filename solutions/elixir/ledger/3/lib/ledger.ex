defmodule Ledger do
  @doc """
  Format the given entries given a currency and locale
  """
  @type currency :: :usd | :eur
  @type locale :: :en_US | :nl_NL
  @type entry :: %{amount_in_cents: integer(), date: Date.t(), description: String.t()}

  @spec format_entries(currency(), locale(), list(entry())) :: String.t()
  def format_entries(_, locale, []), do: header(locale)

  def format_entries(currency, locale, entries) do
    entries =
      Enum.sort(entries, fn a, b ->
        cond do
          a.date.day < b.date.day -> true
          a.date.day > b.date.day -> false
          a.description < b.description -> true
          a.description > b.description -> false
          true -> a.amount_in_cents <= b.amount_in_cents
        end
      end)
      |> Enum.map(fn entry -> format_entry(currency, locale, entry) end)
      |> Enum.join("\n")

    header(locale) <> entries <> "\n"
  end

  defp header(:en_US), do: "Date       | Description               | Change       \n"
  defp header(:nl_NL), do: "Datum      | Omschrijving              | Verandering  \n"

  defp ymd(date) do
    {date.year |> to_string(), date.month |> to_string() |> String.pad_leading(2, "0"),
     date.day |> to_string() |> String.pad_leading(2, "0")}
  end

  defp format_date(date, locale) do
    {year, month, day} = ymd(date)

    if locale == :en_US do
      month <> "/" <> day <> "/" <> year <> " "
    else
      day <> "-" <> month <> "-" <> year <> " "
    end
  end

  defp format_amount(currency, locale, amount_in_cents) do
    number =
      if locale == :en_US do
        decimal =
          amount_in_cents |> abs |> rem(100) |> to_string() |> String.pad_leading(2, "0")

        whole =
          if abs(div(amount_in_cents, 100)) < 1000 do
            abs(div(amount_in_cents, 100)) |> to_string()
          else
            to_string(div(abs(div(amount_in_cents, 100)), 1000)) <>
              "," <> to_string(rem(abs(div(amount_in_cents, 100)), 1000))
          end

        whole <> "." <> decimal
      else
        decimal =
          amount_in_cents |> abs |> rem(100) |> to_string() |> String.pad_leading(2, "0")

        whole =
          if abs(div(amount_in_cents, 100)) < 1000 do
            abs(div(amount_in_cents, 100)) |> to_string()
          else
            to_string(div(abs(div(amount_in_cents, 100)), 1000)) <>
              "." <> to_string(rem(abs(div(amount_in_cents, 100)), 1000))
          end

        whole <> "," <> decimal
      end

    if amount_in_cents >= 0 do
      if locale == :en_US do
        "  #{if(currency == :eur, do: "€", else: "$")}#{number} "
      else
        " #{if(currency == :eur, do: "€", else: "$")} #{number} "
      end
    else
      if locale == :en_US do
        " (#{if(currency == :eur, do: "€", else: "$")}#{number})"
      else
        " #{if(currency == :eur, do: "€", else: "$")} -#{number} "
      end
    end
  end

  defp format_entry(currency, locale, entry) do
    date = format_date(entry.date, locale)

    description =
      if entry.description |> String.length() > 26 do
        " " <> String.slice(entry.description, 0, 22) <> "..."
      else
        " " <> String.pad_trailing(entry.description, 25, " ")
      end

    amount =
      format_amount(currency, locale, entry.amount_in_cents)
      |> String.pad_leading(14, " ")

    date <> "|" <> description <> " |" <> amount
  end
end
