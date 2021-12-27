defmodule MyAppWeb.UserLive.SendReqComponent do
  use MyAppWeb, :live_component

  alias MyApp.Accounts

def handle_event("send_req", %{"value" => user_id} , socket) do
  #    {:noreply, socket}
    send_request(socket, socket.assigns.action, user_id)
  end


  defp send_request(socket, :req, user_id) do
    user = Accounts.get_user!(user_id)
    updated_params = %{
    requests:  user.requests + 1
    }
    case Accounts.update_user(user, updated_params) do
      {:ok, _user} ->
        {:noreply,
          socket
          |> put_flash(:info, "Request Sent successfully")
          |> push_redirect(to: socket.assigns.return_to)
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

end