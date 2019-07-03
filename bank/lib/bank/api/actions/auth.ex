defmodule Bank.API.Actions.Auth do
  alias Bank.Storage.DB, as: DB

  def create_token(user, password) do
    try do
        case DB.match_registration(user, password) do
          true ->
            token = jwt_token(user)
            {:ok, %{token: token}}
          false ->
            {:error, %{reason: "Wrong user or password input"}}
          end
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
