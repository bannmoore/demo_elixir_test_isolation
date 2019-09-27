defmodule TestIsolation.MyModuleCTest do
  use ExUnit.Case, async: true

  alias TestIsolation.MyModuleC

  setup do
    IO.inspect("Setup MyModuleCTest")

    defmodule MySharedModuleMock do
      def do_shared do
        IO.inspect("THIS IS SHARED (FROM MyModuleCTest)")
        send(self(), :do_shared_c)
      end
    end

    IO.inspect(Application.get_env(:test_isolation, :shared_module), label: "Before C Setup")
    Application.put_env(:test_isolation, :shared_module, MySharedModuleMock)
  end

  describe "MyModuleC" do
    test "call_shared_module/0" do
      IO.inspect("MyModuleC test")
      MyModuleC.call_shared_module()
      assert_receive :do_shared_c
    end
  end
end
