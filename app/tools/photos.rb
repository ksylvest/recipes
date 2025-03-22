# frozen_string_literal: true

# @example
#   tool = OmniAI::Tool.new
#   tool.execute(query: "pancakes")
class Photos < OmniAI::Tool
  description "Finds photo URLs by topic (e.g. 'pancakes')."

  parameter :query, :string, description: "A query you are interested in (e.g. pancakes)."
  required %i[query]

  # @param query [String]
  def execute(query:)
    Unsplash::Photo.search(query).map do |photo|
      <<~TEXT
        <photo>
          <url>#{photo['urls']['raw']}</url>
          <width>#{photo['width']}</width>
          <height>#{photo['height']}</height>
          <description>#{photo['description']}</description>
        </photo>
      TEXT
    end.join("\n")
  end
end
