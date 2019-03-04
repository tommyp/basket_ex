defmodule BasketTest do
  use ExUnit.Case
  doctest Basket

  @basket_data %{
    "BR1" => %{
      price: 5.00, # 3 or more is 4.50 each,
      offer: :discount,
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

  test "bogof" do
    {:ok, pid} = Basket.new(@basket_data)
    Basket.add(pid, "MC1")
    Basket.add(pid, "MC1")
    assert(Basket.total(pid) == 3.11)
  end

  test "bogof with other items" do
    {:ok, pid} = Basket.new(@basket_data)
    Basket.add(pid, "MC1")
    Basket.add(pid, "BR1")
    Basket.add(pid, "MC1")
    Basket.add(pid, "PZ1")

    assert(Basket.total(pid) == 19.34)
  end

  test "discount" do
    {:ok, pid} = Basket.new(@basket_data)
    Basket.add(pid, "BR1")
    Basket.add(pid, "BR1")
    Basket.add(pid, "MC1")
    Basket.add(pid, "BR1")

    assert(Basket.total(pid) == 16.61)
  end
end
