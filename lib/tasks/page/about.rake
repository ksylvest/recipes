# frozen_string_literal: true

namespace :page do
  namespace :about do
    desc "generates about.html"
    task :generate do
      data = Context.load
      client = OmniAI::OpenAI::Client.new
      prompt = Liquid::Template.parse(<<~LIQUID)
        Generate an HTML about page for a recipe website using TailwindCSS for styling and AlpineJS and interactivity.

        1. Be responsive where approriate (working on phone / tablet / desktop).

        2. Provide some basic context on the purpose of the site being associated with the following recipe categories:

          <categories>
            {% for category in categories %}
              <category>
                <name>{{ category.name }}</name>
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

      File.open("#{ROOT}/about.html", "w") do |file|
        stream = proc do |chunk|
          next unless chunk.text?

          print(info.text)
          file.write(chunk.text)
        end
        client.chat(prompt.render(data), tools: [Photos.new], stream:)
      end
    end
  end
end
