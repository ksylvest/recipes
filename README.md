# Recipies

A tutorial using [OmniAI](https://github.com/ksylvest/omniai) to build an entire site with LLMs.

```ruby
client = OmniAI::OpenAI::Client.new

client.chat(format: :json) do |prompt|
  prompt.system("You ")
```
