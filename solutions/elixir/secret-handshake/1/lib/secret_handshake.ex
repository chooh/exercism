defmodule SecretHandshake do
  use Bitwise

  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    cond do
      (code >= 32) -> []
      (code &&& 16) > 0 -> Enum.reverse(commands(code - 16))
      (code &&& 1) > 0 -> ["wink" | commands(code - 1)]
      (code &&& 2) > 0 -> ["double blink" | commands(code - 2)]
      (code &&& 4) > 0 -> ["close your eyes" | commands(code - 4)]
      (code &&& 8) > 0 -> ["jump" | commands(code - 8)]
      true -> []
    end
  end
end
