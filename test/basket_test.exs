defmodule BasketTest do
  use ExUnit.Case
  doctest Basket

  @basket_data %{
    "BR1" => %{
      price: 5.00, # 3 or more is 4.50 each,
    },
    "MC1" => %{
      price: 3.11,
      offer: :bogof,
    },
    "PZ1" => %{
      price: 11.23,
    }
  }

  test "add one item" do
    {:ok, pid} = Basket.new(@basket_data)
    Basket.add(pid, "MC1")
    assert(Basket.total(pid) == 3.11)
  end

  test "adds items together" do
    {:ok, pid} = Basket.new(@basket_data)
    Basket.add(pid, "MC1")
    Basket.add(pid, "BR1")
    Basket.add(pid, "MC1")
    Basket.add(pid, "PZ1")

    assert(Basket.total(pid) == 19.34)
  end
end
