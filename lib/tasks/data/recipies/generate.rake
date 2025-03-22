namespace :data do
  namespace :recipies do
    desc "generates recipies within 'data.yml'"
    task :generate do
      Context.manage do |data|
        data["categories"].each do |category|
          client = OmniAI::OpenAI::Client.new(logger: Logger.new($stdout))
          response = client.chat(format: :json) do |prompt|
            prompt.user <<~TEXT
              Generate a JSON list 20-40 recipes for the category "#{category["name"]}".

              1. The response should include a name / slug for each recipe.
              2. The name / slug should be unique within the category.
              3. Be creative with your naming while keeping the core idea grounded and reasonable.
              4. Make sure that every entry sounds delicious.

              EXAMPLE:

              """
                {
                  "recipes": [
                    {
                      "name": "Triple Almond Cherry Crumble Squares",
                      "slug": "triple-almond-cherry-crumble-squares",
                    },
                    ...
                  ]
                }
              """
            TEXT
          end
          category["recipes"] = JSON.parse(response.text)["recipes"]
        end
      end
    end
  end
end
