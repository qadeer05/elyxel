defmodule Elyxel.AuthorizeTest do
  use Elyxel.ConnCase

  import Elyxel.OpenmaizeEcto
  import OpenmaizeJWT.Create
  alias Elyxel.{Repo, User}

  @valid_attrs %{email: "tony@mail.com", password: "mangoes&g0oseberries"}
  @invalid_attrs %{email: "tony@mail.com", password: "maaaangoes&g00zeberries"}

  {:ok, user_token} = %{id: 3, email: "tony@mail.com", role: "user"}
                      |> generate_token({0, 86400})
  @user_token user_token

  setup do
    conn = conn()
    |> put_req_cookie("access_token", @user_token)
    {:ok, conn: conn}
  end

  test "login succeeds" do
    # Remove the Repo.get_by line if you are not using email confirmation
    Repo.get_by(User, %{email: "tony@mail.com"}) |> user_confirmed
    conn = post conn, "/login", user: @valid_attrs
    assert redirected_to(conn) == "/users"
  end

  test "login fails" do
    # Remove the Repo.get_by line if you are not using email confirmation
    Repo.get_by(User, %{email: "reg@mail.com"}) |> user_confirmed
    conn = post conn, "/login", user: @invalid_attrs
    assert redirected_to(conn) == "/login"
  end

  test "logout succeeds" do
  {:ok, user_token} = %{id: 3, email: "tony@mail.com", role: "user"}
                      |> generate_token({0, 86400})
    conn = conn()
    |> put_req_cookie("access_token", user_token)
    |> get("/logout")
    assert redirected_to(conn) == "/"
  end

end
