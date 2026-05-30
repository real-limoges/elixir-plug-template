# Populates the database with a sample user so the example flow returns data.
#
#     mix run priv/repo/seeds.exs
#
# It is idempotent: running it repeatedly will not create duplicate users. The
# user is inserted with id 1 so the documented `curl` (user_id: 1) works.

alias Relay.Repo
alias Relay.User

now = DateTime.utc_now() |> DateTime.truncate(:second)

case Repo.get(User, 1) do
  nil ->
    Repo.insert!(%User{
      id: 1,
      created_at: now,
      updated_at: now,
      last_active: now
    })

  _user ->
    :ok
end
