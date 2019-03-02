require IEx

defmodule Basket do
  use GenServer

  @moduledoc """
  Documentation for Basket.
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

  def init(state) do
    init_state = %{
      total: 0,
      items: []
    }

    state = Map.put(init_state, :pricing_rules, state)

    {:ok, state}
  end

  def handle_cast({:add, item_code}, state) do
    unit = Map.get(state[:pricing_rules], item_code)

    {_, state} = Map.get_and_update!(state, :items, fn(current_items) ->
      {current_items, [item_code | current_items]}
    end)

    {_, state} = state
                |> Map.get_and_update(:total, fn(total) ->
                  {total, total + unit[:price]}
                end)

    state = apply_offer(state, unit)

    {:noreply, state}
  end

  def handle_call(:total, _from, state) do
    total = Map.get(state, :total)

    {:reply, total, state}
  end

  def apply_offer(state, unit, :bogof) do
    items = Map.get(state, :items)

    count = Enum.count(items, fn(item) -> item == Map.keys(unit)[0] end)

    state = Map.get_and_update(state, :total, fn(total) ->
      total = total - (unit[:price] / count)
    end)

    state
  end

  def apply_offer(state, _) do
    state
  end
end
