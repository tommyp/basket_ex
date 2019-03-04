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
    GenServer.call(pid, :total, :infinity)
  end

  # API

  def init(state) do
    init_state = %{
      subtotal: 0,
    }

    state = Map.put(init_state, :items, state)

    {:ok, state}
  end

  def handle_cast({:add, item_code}, state) do
    item = Map.get(state[:items], item_code)

    item =
      if quantity = Map.get(item, :quantity) do
        Map.put(item, :quantity, quantity + 1)
      else
        Map.put(item, :quantity, 1)
      end

    items = Map.put(state[:items], item_code, item)

    state = Map.put(state, :items, items)

    {_, state} = state
                |> Map.get_and_update(:subtotal, fn(subtotal) ->
                  {subtotal, subtotal + item[:price]}
                end)

    {:noreply, state}
  end

  def handle_call(:total, _from, state) do
    total = calculate_item_prices(state)

    {:reply, total, state}
  end

  def calculate_item_prices(state) do
    state[:items]
    |> Enum.filter(fn({code, item}) -> Map.has_key?(item, :quantity) end)
    |> Enum.map(fn({code, item}) ->
      if offer = Map.get(item, :offer) do
        total = apply_offer(item, offer)
      else
        total = item[:quantity] * item[:price]
      end

      total
    end)
    |> Enum.sum
  end

  def apply_offer(item, :bogof) do
    if item[:quantity] >= 2 do
      case rem(item[:quantity], 2) do
        0 -> (item[:quantity] / 2) * item[:price]
        _ -> ((item[:quantity] - 1)/ 2) * item[:price]
      end
    else
      item[:price]
    end
  end

  def apply_offer(item, :discount) do
    if item[:quantity] >= 3 do
      item[:quantity] * (item[:price] - 0.5)
    else
      item[:quantity] * item[:price]
    end
  end

  def apply_offer(item, _) do
    item[:price]
  end
end
