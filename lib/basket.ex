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
    GenServer.start_link(__MODULE__, pricing_rules)
  end

  def add(pid, item_code) do
    GenServer.cast(pid, {:add, item_code})
  end

  def total(pid) do
    GenServer.call(pid, :total)
  end

  # API

  # def handle_cast({:set_pricing_rules, pricing_rules}, state) do
  #   state = Map.put(state, pricing_rules)

  #   {:noreply, state}
  # end

  def init(state) do
    state = Map.put(%{total: 0}, :pricing_rules, state)

    {:ok, state}
  end

  def handle_cast({:add, item_code}, state) do
    total = Map.get(state, :total)

    unit_cost = Map.get(state[:pricing_rules], item_code)

    state = Map.put(state, :total, total + unit_cost)

    {:noreply, state}
  end

  def handle_call(:total, _from, state) do
    total = Map.get(state, :total)

    {:reply, total, state}
  end
end
