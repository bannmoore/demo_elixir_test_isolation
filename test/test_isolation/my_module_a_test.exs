defmodule TestIsolation.MyModuleATest do
  use ExUnit.Case, async: true

  alias TestIsolation.MyModuleA

  setup do
    IO.inspect("Setup MyModuleATest")

    defmodule MySharedModuleMock do
      def do_shared do
        IO.inspect("THIS IS SHARED (FROM MyModuleATest)")
        send(self(), :do_shared_a)
      end
    end

    IO.inspect(Application.get_env(:test_isolation, :shared_module), label: "Before A Setup")
    Application.put_env(:test_isolation, :shared_module, MySharedModuleMock)
  end

  describe "MyModuleA" do
    test "call_shared_module/0" do
      IO.inspect("MyModuleA test")
      MyModuleA.call_shared_module()
      assert_receive :do_shared_a
    end
  end
end
