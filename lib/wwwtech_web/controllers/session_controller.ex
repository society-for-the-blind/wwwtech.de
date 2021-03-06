defmodule WwwtechWeb.SessionController do
  use WwwtechWeb.Web, :controller
  use WwwtechWeb.Web, :web_controller

  def new(conn, _params) do
    if logged_in?(conn) do
      conn
      |> put_flash(:info, "You are already logged in")
      |> redirect(to: "/")
    else
      render(conn, "new.html")
    end
  end

  def create(conn, %{"session" => session_params}) do
    case Wwwtech.Accounts.Session.login(session_params, Wwwtech.Repo) do
      {:ok, user} ->
        conn
        |> maybe_put_remember(user, session_params["remember_me"])
        |> put_session(:current_user, user.id)
        |> configure_session(renew: true)
        |> put_flash(:info, "Logged in")
        |> redirect(to: "/")

      :error ->
        conn
        |> put_flash(:info, "Wrong email or password")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> configure_session(drop: true)
    |> delete_resp_cookie("remember_me")
    |> put_flash(:info, "Logged out")
    |> redirect(to: "/")
  end

  defp maybe_put_remember(conn, user, "true") do
    token = Phoenix.Token.sign(WwwtechWeb.Endpoint, "user", user.id)
    put_resp_cookie(conn, "remember_me", token, max_age: 30 * 24 * 60 * 60, http_only: true)
  end

  defp maybe_put_remember(conn, _, _), do: conn
end
