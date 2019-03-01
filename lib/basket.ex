defmodule Basket do
  use GenServer
  @moduledoc """
  Documentation for Basket.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Basket.hello
      :world

  """
  def new(pricing_rules) do
    {:ok, pid} = GenServer.start_link(__MODULE__)

    set_pricing_rules(pricing_rules)

    pid
  end

  def add(pid, item_code) do
    GenServer.cast(pid, {:add, item_code})
  end

  # API

  def start_link(pricing_rules) do
    {:ok, args}
  end

  def handle_cast({:set_pricing_rules, pricing_rules}, state) do
    state = Map.put(state, pricing_rules)

    {:noreply, state}
  end

  def handle_cast({:add, item_code}, state) do

  end
end
