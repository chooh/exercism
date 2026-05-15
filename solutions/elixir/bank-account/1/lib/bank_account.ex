defmodule BankAccount do
  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  use GenServer

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank. Makes the account available.
  """
  @spec open_bank() :: account
  def open_bank() do
    {:ok, pid} = GenServer.start_link(__MODULE__, 0)
    pid
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: none
  def close_bank(account) do
    GenServer.cast(account, :close)
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(account) do
    GenServer.call(account, :balance)
  end

  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  @spec update(account, integer) :: any
  def update(account, amount) do
    GenServer.call(account, {:update, amount})
  end

  @impl true
  def init(initial_balance), do: {:ok, initial_balance}

  @impl true
  def handle_call(:balance, _from, nil), do: {:reply, {:error, :account_closed}, nil}
  def handle_call(:balance, _from, balance), do: {:reply, balance, balance}

  @impl true
  def handle_call({:update, _amount}, _from, nil), do: {:reply, {:error, :account_closed}, nil}
  def handle_call({:update, amount}, _from, balance), do: {:reply, :ok, balance + amount}

  @impl true
  def handle_cast(:close, balance), do: {:noreply, nil}
end
