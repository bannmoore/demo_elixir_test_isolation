# TestIsolation

This is a demo repository to demonstrate side effects in tests when using `Application.get_env` and `Application.put_env` to provide mocks.

There are three modules (`MyModuleA`, `MyModuleB`, and `MyModuleC`), each of which has a dependency on `MySharedModule` using `get_env`. There are also three tests, one for each module.

- `MyModuleATest` and `MyModuleCTest` use `put_env` to insert a mock `MySharedModule` into the environment.
- `MyModuleBTest` tests whatever is in the environment (which should be the default, the real `MySharedModule`)

Run tests in random order:

```sh
mix test --seed $(date +%s)
```

If you run this command a few times, you'll notice that whether the tests pass or fail depends on which order they run in. `B -> C -> A` passes, because both C and A override whatever is in the current enviroment.

If B runs _after_ A or C, though, it fails, because the previous tests environmental overrides leak. From the `IO.inspect` statements, you can see that a previous test's mock persists in the environment during the next test's `setup`.

This behavior occurs whether or not `async: true` is provided.

```
"Setup MyModuleBTest"
Before B Setup: nil
"MyModuleB test"
"THIS IS SHARED"
"Setup MyModuleCTest"
Before C Setup: nil
"MyModuleC test"
"THIS IS SHARED (FROM MyModuleCTest)"
"Setup MyModuleATest"
Before A Setup: TestIsolation.MyModuleCTest.MySharedModuleMock
"MyModuleA test"
"THIS IS SHARED (FROM MyModuleATest)"
```

In order to properly isolate the tests, every evironmental change needs to be reverted in an `on_exit`, like so:

```elixir
  setup do
    defmodule MySharedModuleMock do
      def do_shared do
        send(self(), :do_shared_c)
      end
    end

    Application.put_env(:test_isolation, :shared_module, MySharedModuleMock)

    on_exit(fn ->
      Application.delete_env(:test_isolation, :shared_module)
    end)
  end
```
