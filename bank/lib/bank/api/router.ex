defmodule Bank.API.Router do
  use Raxx.Router
  alias Bank.API.Actions

  def stack(config) do
    Raxx.Stack.new(
      [
        # Add global middleware here.
      ],
      {__MODULE__, config}
    )
  end

  section [{Raxx.Logger, Raxx.Logger.setup(level: :info)}], [
    {%{path: ["acounts","withdraw"]}, Actions.WelcomeMessage},
    {%{path: ["acounts","deposit"]}, Actions.WelcomeMessage},
    {%{path: ["users", "auth"]}, Actions.Users},
    {%{path: ["users", "singup"]}, Actions.Users},
  ]

  section [{Raxx.Logger, Raxx.Logger.setup(level: :debug)}], [
    {_, Actions.NotFound}
  ]
end
