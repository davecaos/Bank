defmodule Bank.API.Actions.Signup do
  alias Bank.Storage.DB, as: DB
    def execute(user, password) do
        try do
            DB.signup(user, password)
            {:ok, {:acounts, acounts}} = DB.add_acount_to(user)
            token = jwt_token(user)
            {:ok, %{token: token, acounts: acounts}}
        rescue
          _error in RuntimeError -> {:error, %{reason: "Internal error"}}
        end
    end

    defp jwt_token(user) do
      signer = Joken.Signer.parse_config(:rsa_signer)
      token = Joken.generate_and_sign!(%{}, %{"user" => user}, signer)
      token
    end
end
