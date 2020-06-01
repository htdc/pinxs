defmodule PINXS.Webhooks.WebhookTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias PINXS.Webhooks.Webhook

  test "Creates a webhook" do
    use_cassette("webhooks/create") do
      {:ok, webhook} =
        Webhook.create(
          %Webhook{url: "https://www.example.com/webhooks"},
          PINXS.config("api_key", :test)
        )

      assert webhook.token != nil
    end
  end

  test "Retrieve webooks" do
    use_cassette("webhooks/get_all") do
      {:ok, webhook} =
        Webhook.create(
          %Webhook{url: "https://www.example.com/webhooks"},
          PINXS.config("api_key", :test)
        )

      {:ok, [retreived_hook]} = Webhook.get(PINXS.config("api_key", :test))

      assert webhook == retreived_hook
    end
  end

  test "Retrieve specific webhook" do
    use_cassette("webhooks/get") do
      {:ok, webhook} =
        Webhook.create(
          %Webhook{url: "https://www.example.com/webhooks"},
          PINXS.config("api_key", :test)
        )

      {:ok, retreived_hook} = Webhook.get(webhook.token, PINXS.config("api_key", :test))

      assert webhook == retreived_hook
    end
  end

  test "Delete webhook" do
    use_cassette("webhooks/delete") do
      {:ok, webhook} =
        Webhook.create(
          %Webhook{url: "https://www.example.com/webhooks"},
          PINXS.config("api_key", :test)
        )

      {:ok, result} = Webhook.delete(webhook.token, PINXS.config("api_key", :test))

      assert result
    end
  end
end
