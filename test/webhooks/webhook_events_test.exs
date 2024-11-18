defmodule PINXS.Webhooks.WebhookEventTest do
  use ExUnit.Case, async: true

  alias PINXS.Webhooks.Event

  use Nug,
    upstream_url: PINXS.Client.test_url(),
    client_builder: &PINXS.TestClient.setup/1

  test "Get webhook events" do
    with_proxy("webhooks/events/get_all.fixture") do
      {:ok, events} = Event.get_all(client)

      assert length(events) == 75
    end
  end

  test "Gets webhook event" do
    with_proxy("webhooks/events/get.fixture") do
      {:ok, event} = Event.get("evt_4t2D3ges-DNWyaxfg0zQ8Q", client)


      assert event.token == "evt_4t2D3ges-DNWyaxfg0zQ8Q"
      assert event.type == "transfer.created"
    end
  end
end
