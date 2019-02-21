defmodule Stripe.FileRequest do
  @moduledoc """
  This module contains the guts for performing HTTP requests to stripe.

  Usage: Add the following lines to a module

    def Stripe.ExampleEndpoint
      use Stripe.FileRequest

      @endpoint "example_endpoint"
    end

  Then you can begin filling out the rest of the module
  depending on the type of request you need to make.
  """

  defmacro __using__(_opts) do
    quote do

      use HTTPoison.Base

      def make_request(method, endpoint, key, body, opts \\ []) do
        request(method, endpoint, {:multipart, body}, headers(key), opts)
      end

      def process_url(endpoint) do
        "https://files.stripe.com/v1/" <> endpoint
      end

      def process_response_body(body) do
        Jason.decode!(body)
      end

      def headers(key) do
        [
          {"Authorization", "Bearer #{key}"},
          {"User-Agent", "Stripe/v1 scalpel/0.1.0"},
          {"Content-Type", "multipart/form-data"},
          {"Stripe-Version", "2018-05-21"}
        ]
      end
    end
  end
end
