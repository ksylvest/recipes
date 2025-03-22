# frozen_string_literal: true

namespace :page do
  namespace :categories do
    desc "generates categories/:slug.html"
    task :generate do
      data = Context.load

      data["categories"].each do |category|
        client = OmniAI::OpenAI::Client.new(logger: Logger.new($stdout))
        prompt = Liquid::Template.parse(<<~LIQUID)
          Generate HTML for a page focused on "{{ category.name }}"

          1. Use TailwindCSS for styling and AlpineJS for interactivity being sure to include this snippet in the head:

            ```html
            <script src="https://unpkg.com/alpinejs"></script>
            <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
            ```

          2. Be responsive where approriate (working on phone / tablet / desktop).

          3. Link to the following recipies:

            <categories>
              {% for recipe in category.recipies %}
                <category>
                  <name>{{ recipe.name }}</name>
                  <url>/recipies/{{ recipe.slug }}</url>
                </category>
              {% endfor %}
            </categories>

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

        File.open("#{ROOT}/categories/#{category['slug']}.html", "w") do |file|
          stream = proc { |chunk| file.write(chunk.text) if chunk.text? }
          client.chat(prompt.render(category), tools: [Photos.new], stream:)
        end
      end
    end
  end
end
