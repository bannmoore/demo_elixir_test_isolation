defmodule TestIsolation.MySharedModule do
  @moduledoc """
  """

  def do_shared() do
    IO.inspect("THIS IS SHARED")
  end
end
