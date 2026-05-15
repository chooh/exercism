defmodule ProteinTranslation do
  @doc """
  Given an RNA string, return a list of proteins specified by codons, in order.
  """
  @spec of_rna(String.t()) :: {atom, list(String.t())}
  def of_rna(rna), do: of_rna(rna, {:ok, []})

  defp of_rna("", acc), do: acc

  defp of_rna(_, {:error, _} = error), do: error

  defp of_rna(rna, {:ok, list}) do
    {codon, rest} = String.split_at(rna, 3)

    case of_codon(codon) do
      {:ok, "STOP"} -> {:ok, list}
      {:ok, protein} -> of_rna(rest, {:ok, list ++ [protein]})
      _ -> {:error, "invalid RNA"}
    end
  end

  @doc """
  Given a codon, return the corresponding protein

  UGU -> Cysteine
  UGC -> Cysteine
  UUA -> Leucine
  UUG -> Leucine
  AUG -> Methionine
  UUU -> Phenylalanine
  UUC -> Phenylalanine
  UCU -> Serine
  UCC -> Serine
  UCA -> Serine
  UCG -> Serine
  UGG -> Tryptophan
  UAU -> Tyrosine
  UAC -> Tyrosine
  UAA -> STOP
  UAG -> STOP
  UGA -> STOP
  """
  @spec of_codon(String.t()) :: {atom, String.t()}
  def of_codon("AUG"), do: {:ok, "Methionine"}
  def of_codon("UUU"), do: {:ok, "Phenylalanine"}
  def of_codon("UUC"), do: {:ok, "Phenylalanine"}
  def of_codon("UUA"), do: {:ok, "Leucine"}
  def of_codon("UUG"), do: {:ok, "Leucine"}
  def of_codon("UCU"), do: {:ok, "Serine"}
  def of_codon("UCC"), do: {:ok, "Serine"}
  def of_codon("UCA"), do: {:ok, "Serine"}
  def of_codon("UCG"), do: {:ok, "Serine"}
  def of_codon("UAU"), do: {:ok, "Tyrosine"}
  def of_codon("UAC"), do: {:ok, "Tyrosine"}
  def of_codon(codon) when codon in ["UGU", "UGC"], do: {:ok, "Cysteine"}
  def of_codon("UGG"), do: {:ok, "Tryptophan"}
  def of_codon(codon) when codon in ["UAA", "UAG", "UGA"], do: {:ok, "STOP"}

  def of_codon(_) do
  end
end
