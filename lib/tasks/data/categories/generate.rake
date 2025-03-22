namespace :data do
  namespace :categories do
    desc "generates categories within 'data.yml'"
    task :generate do
      Context.manage do |data|
        client = OmniAI::OpenAI::Client.new(logger: Logger.new($stdout))
        response = client.chat(format: :json, logger: Logger.new($stdout)) do |prompt|
          prompt.user <<~TEXT
            Generate a JSON list of categories for recipies (e.g. Breakfast, Lunch, Dinner, Dessert, etc.).

            EXAMPLE:

            """
            {
              "categories": [
                {
                  "name": "Breakfast",
                  "slug": "breakfast",
                },
                {
                  "name": "Lunch",
                  "slug": "lunch",
                }
              ]
            }
            """
          TEXT
        end

        data["categories"] = JSON.parse(response.text)["categories"]
      end
    end
  end
end
