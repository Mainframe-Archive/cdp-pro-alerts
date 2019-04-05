defmodule CdpPro.Worker do
  use GenServer
  alias CdpPro.Alert
  alias CdpPro.Contract
  alias CdpPro.Email
  alias CdpPro.Mailer

  @polling_interval Application.get_env(:cdp_pro, :polling_interval)

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    Alert.get_all_active_subscriptions()
    |> Enum.map(fn sub ->
      {Contract.get_collateralization_ratio(sub.cdp_id), sub}
    end)
    |> Enum.filter(fn {collateralization_ratio, sub} ->
      collateralization_ratio >= sub.warn_ratio
    end)
    |> Enum.each(fn {_, sub} ->
      Email.warning_email(sub) |> Mailer.deliver_later()
    end)

    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, @polling_interval * 1000)
  end
end
