# frozen_string_literal: true

namespace :page do
  namespace :home do
    desc "generates index.html"
    task :generate do
      data = Context.load
      client = OmniAI::OpenAI::Client.new(logger: Logger.new($stdout))
      prompt = Liquid::Template.parse(<<~LIQUID)
        Generate an HTML home page for a website using TailwindCSS for styling and AlpineJS and interactivity.

        1. Be responsive where approriate (working on phone / tablet / desktop).

        2. Link to the following categories:

          <categories>
            {% for category in categories %}
              <category>
                <name>{{ category.name }}</name>
                <url>/categories/{{ category.slug }}</url>
              </category>
            {% endfor %}
          </categories>

        3. Include the following snippet in the head to ensure AlpineJS and TailwindCSS work:

          ```html
          <script src="https://unpkg.com/alpinejs"></script>
          <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
          ```

        4. The page needs to be optimized for SEO (e.g. title / meta / etc).

        5. The page needs to be visually stunning.

        6. Provide all copy (and be creative) to ensure the page is engaging.

        8. For photos please use the "photos" tool and be sure to include the width / height / url.

        9. Do not give back the HTML inside a markdown code block or provide any commentary.


        EXAMPLE:

        """
          <!DOCTYPE html>
          <html lang="en">
            <head>
              ...
            </head>
            <body>
              ...
            </body>
          </html>
      LIQUID

      File.open("#{ROOT}/index.html", "w") do |file|
        stream = proc { |chunk| file.write(chunk.text) if chunk.text? }
        client.chat(prompt.render(data), tools: [Photos.new], stream:)
      end
    end
  end
end
