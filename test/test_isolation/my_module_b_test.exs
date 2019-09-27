defmodule TestIsolation.MyModuleBTest do
  use ExUnit.Case, async: true

  alias TestIsolation.MyModuleB

  setup do
    Process.sleep(1000)

    IO.inspect("Setup MyModuleBTest")
    IO.inspect(Application.get_env(:test_isolation, :shared_module), label: "Before B Setup")

    :ok
  end

  describe "MyModuleB" do
    test "call_shared_module/0" do
      IO.inspect("MyModuleB test")
      MyModuleB.call_shared_module()
      refute_receive :do_shared_a
      refute_receive :do_shared_b
    end
  end
end
