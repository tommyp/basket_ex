defmodule BasketTest do
  use ExUnit.Case
  doctest Basket

  test "greets the world" do
    assert Basket.hello() == :world
  end

  @basket_data %{
    "BR1" => 5.00, # 3 or more is 4.50 each
    "MC1" => 3.11,
    "PZ1" => 11.23,
  }

  pricing_rules = %{"BR1" => 5.00, "MC1" => 3.11, "PZ1" => 11.23}

  test "add one item" do
    {:ok, pid} = Basket.new(@basket_data)
    Basket.add(pid, "MC1")
    assert(Basket.total(pid) == 3.11)
  end

  test "adds items together" do
    {:ok, pid} = Basket.new(@basket_data)
    Basket.add("MC1")
    Basket.add("BR1")
    Basket.add("MC1")
    Basket.add("PZ1")
    actual = Basket.total

    assert(actual == 19.34)
  end
end
