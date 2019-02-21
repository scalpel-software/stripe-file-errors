defmodule Stripe.File do
  @moduledoc false

  use Stripe.FileRequest

  @endpoint "files"

  def create(body, key) do
    make_request(:post, @endpoint, key, body)
  end

  def body_to_utf8(body) do
    {info, length} = :hackney_multipart.encode_form(body)
    Enum.join(for <<c::utf8 <- info>>, do: <<c::utf8>>)
  end
end