defmodule PINXS.Webhooks.WebhookTest do
  use ExUnit.Case, async: true

  alias PINXS.Webhooks.Webhook
  use Nug
  import PINXS.TestHelpers

  test "Creates a webhook" do
    with_proxy(PINXS.Client.test_url(), "test/fixtures/webhooks/create.fixture") do
      {:ok, webhook} =
        Webhook.create(
          %Webhook{url: "https://www.example.com/webhooks"},
          client(address)
        )

      assert webhook.token != nil
    end
  end

  test "Retrieve webooks" do
    with_proxy(PINXS.Client.test_url(), "test/fixtures/webhooks/get_all.fixture") do
      client = client(address)

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
    with_proxy(PINXS.Client.test_url(), "test/fixtures/webhooks/get.fixture") do
      client = client(address)

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
    with_proxy(PINXS.Client.test_url(), "test/fixtures/webhooks/delete.fixture") do
      client = client(address)

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
