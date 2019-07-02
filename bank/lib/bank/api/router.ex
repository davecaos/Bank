defmodule Bank.API.Router do
  use Raxx.Router
  alias Bank.API.Actions
  alias Bank.API.Handlers

  def stack(config) do
    Raxx.Stack.new(
      [
        # Add global middleware here.
      ],
      {__MODULE__, config}
    )
  end

  section [{Raxx.Logger, Raxx.Logger.setup(level: :info)}], [
    {%{path: ["transactions"]}, Handlers.Transactions },
    {%{path: ["balances"]}, Handlers.Balances },
    {%{path: ["auth"]}, Actions.Auth},
    {%{path: ["signup"]}, Actions.Signup},
    {%{path: ["status"]}, Handlers.Status},
  ]

  section [{Raxx.Logger, Raxx.Logger.setup(level: :debug)}], [
    {_, Actions.NotFound}
  ]
end
