This is a quick repo that demonstrates an issue that I'm having with file uploads to Stripe

Our servers do not have a read only file system so I cannot pass a file path to hackney, I can only pass in the contents of the file.

When doing so I receive an "invalid_request_error", with an "Invalid Hash" message

You can reproduce this issue by doing the following

```
  $: mix deps.get
  $: mix deps.compile
  $: iex -S mix

  $: {:ok, path} = File.cwd()
  $: secret_key = __REPLACE_WITH_STRIPE_SECRET_KEY__
  $: phoenix_img = "#{path}/assets/images/phoenix.png"
  $: {:ok, file} = File.read(phoenix_img)
  $: bad_body = [{"purpose", "dispute_evidence"}, {"file", file, [{"content-type", "image/png"}, {"filename", "phoenix.png"}]}]
  $: {:ok, fail_response} = Stripe.File.create(body, secret_key)
```

Everything else works if I follow the traditional method of just passing in a file path as described in the docs of hackney

```
  $: iex -S mix

  $: {:ok, path} = File.cwd()
  $: secret_key = __REPLACE_WITH_STRIPE_SECRET_KEY__
  $: phoenix_img = "#{path}/assets/images/phoenix.png"
  $: good_body = [{"purpose", "dispute_evidence"}, {:file, phoenix_img}]
  $: {:ok, response} = Stripe.File.create(body, secret_key)
```

Here is the relevant code for hackney's multipart handling

https://github.com/benoitc/hackney/blob/master/src/hackney_multipart.erl#L56

I am attempting to fake the form encoding that works via pattern matching on line 58 by duplicating the params and going through the path on line 100. The resulting value *looks good to me* but obviously fails when attempting to upload to stripe.

You can check the resulting encodings against one another by using the following function:

```
$: Stripe.File.body_to_utf8(bad_body)
$: Stripe.File.body_to_utf8(good_body)
```

Is there something that I'm missing? I think this should work but I could be missing a step.