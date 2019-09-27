defmodule TestIsolation.MyModuleC do
  @moduledoc """
  """

  def do_c do
    IO.inspect("THIS IS C")
  end

  def call_shared_module do
    shared_module().do_shared()
  end

  defp shared_module do
    Application.get_env(:test_isolation, :shared_module, TestIsolation.MySharedModule)
  end
end
