defmodule PINXS.Webhooks.WebhookTest do
  use ExUnit.Case, async: true

  alias PINXS.Webhooks.Webhook
  use Nug,
    upstream_url: PINXS.Client.test_url(),
    client_builder: &PINXS.TestClient.setup/1

  test "Creates a webhook" do
    with_proxy("webhooks/create.fixture") do
      {:ok, webhook} =
        Webhook.create(
          %Webhook{url: "https://www.example.com/webhooks"},
          client
        )

      assert webhook.token != nil
    end
  end

  test "Retrieve webooks" do
    with_proxy("webhooks/get_all.fixture") do
      client = client

      {:ok, webhook} =
        Webhook.create(
          %Webhook{url: "https://www.example.com/webhooks2"},
          client
        )

      {:ok, [retreived_hook | _]} = Webhook.get(client)

      assert webhook == retreived_hook
    end
  end

  test "Retrieve specific webhook" do
    with_proxy("webhooks/get.fixture") do
      {:ok, webhook} =
        Webhook.create(
          %Webhook{url: "https://www.example.com/webhooks3"},
          client
        )

      {:ok, retreived_hook} = Webhook.get(webhook.token, client)

      assert webhook == retreived_hook
    end
  end

  test "Delete webhook" do
    with_proxy("webhooks/delete.fixture") do
      {:ok, webhook} =
        Webhook.create(
          %Webhook{url: "https://www.example.com/webhooks4"},
          client
        )

      {:ok, result} = Webhook.delete(webhook.token, client)

      assert result
    end
  end
end
