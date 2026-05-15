defmodule ComplexNumbers do
  import Kernel, except: [div: 2]

  @typedoc """
  In this module, complex numbers are represented as a tuple-pair containing the real and
  imaginary parts.
  For example, the real number `1` is `{1, 0}`, the imaginary number `i` is `{0, 1}` and
  the complex number `4+3i` is `{4, 3}'.
  """
  @type complex :: {number, number}

  @doc """
  Return the real part of a complex number
  """
  @spec real(a :: complex) :: number
  def real({r, _}), do: r

  @doc """
  Return the imaginary part of a complex number
  """
  @spec imaginary(a :: complex) :: number
  def imaginary({_, i}), do: i

  @doc """
  Multiply two complex numbers, or a real and a complex number
  """
  @spec mul(a :: complex | number, b :: complex | number) :: complex
  def mul({a, b}, {c, d}), do: {a * c - b * d, b * c + a * d}
  def mul(x, {a, b}), do: {x * a, x * b}
  def mul({a, b}, x), do: {x * a, x * b}

  @doc """
  Add two complex numbers, or a real and a complex number
  """
  @spec add(a :: complex | number, b :: complex | number) :: complex
  def add({a, b}, {c, d}), do: {a + c, b + d}
  def add(x, {c, d}), do: add({x, 0}, {c, d})
  def add({a, b}, x), do: add({a, b}, {x, 0})

  @doc """
  Subtract two complex numbers, or a real and a complex number
  """
  @spec sub(a :: complex | number, b :: complex | number) :: complex
  def sub({a, b}, {c, d}), do: {a - c, b - d}
  def sub(x, {c, d}), do: sub({x, 0}, {c, d})
  def sub({a, b}, x), do: sub({a, b}, {x, 0})

  @doc """
  Divide two complex numbers, or a real and a complex number
  """
  @spec div(a :: complex | number, b :: complex | number) :: complex
  def div({a, b}, {c, d}) when not (c == 0 and d == 0) do
    denominator = c ** 2 + d ** 2
    {(a * c + b * d) / denominator, (b * c - a * d) / denominator}
  end

  def div({a, b}, x), do: div({a, b}, to_complex(x))
  def div(x, {c, d}), do: div(to_complex(x), {c, d})

  @doc """
  Absolute value of a complex number
  """
  @spec abs(a :: complex) :: number
  def abs({a, b}), do: :math.sqrt(a ** 2 + b ** 2)

  @doc """
  Conjugate of a complex number
  """
  @spec conjugate(a :: complex) :: complex
  def conjugate({a, b}), do: {a, -b}

  @doc """
  Exponential of a complex number
  """
  @spec exp(a :: complex) :: complex
  def exp({a, b}) do
    magnitude = :math.exp(a)
    {magnitude * :math.cos(b), magnitude * :math.sin(b)}
  end

  @spec to_complex(x :: number) :: complex
  defp to_complex(x), do: {x, 0}
end
