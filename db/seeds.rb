# Default tools for Nook
# These are the curated "popular" tools users can quickly add to their stack

default_tools = [
  { name: "Notion", description: "All-in-one workspace for notes, docs, and databases", platform: "Web", category: "Productivity" },
  { name: "Figma", description: "Collaborative design and prototyping tool", platform: "Web", category: "Design" },
  { name: "Slack", description: "Team communication and collaboration platform", platform: "Web", category: "Communication" },
  { name: "Linear", description: "Issue tracking and project management for software teams", platform: "Web", category: "Productivity" },
  { name: "Cursor", description: "AI-powered code editor built on VS Code", platform: "Mac", category: "Development" },
  { name: "Canva", description: "Graphic design tool for non-designers", platform: "Web", category: "Design" },
  { name: "Obsidian", description: "Personal knowledge base with linked notes", platform: "Mac", category: "Productivity" },
  { name: "Todoist", description: "Task management and to-do list app", platform: "Web", category: "Productivity" },
  { name: "Spotify", description: "Music and podcast streaming service", platform: "Web", category: "Entertainment" },
  { name: "Discord", description: "Community chat and voice platform", platform: "Web", category: "Communication" },
  { name: "Zoom", description: "Video meetings and webinars", platform: "Web", category: "Communication" },
  { name: "Gmail", description: "Email service by Google", platform: "Web", category: "Communication" },
  { name: "Google Calendar", description: "Scheduling and calendar management", platform: "Web", category: "Productivity" },
  { name: "Safari", description: "Web browser by Apple", platform: "Mac", category: "Utilities" },
  { name: "VS Code", description: "Code editor with extensive extensions", platform: "Mac", category: "Development" }
]

default_tools.each do |tool_data|
  Tool.find_or_create_by!(name: tool_data[:name]) do |tool|
    tool.description = tool_data[:description]
    tool.platform = tool_data[:platform]
    tool.category = tool_data[:category]
    tool.is_default = true
  end
end

puts "Seeded #{default_tools.count} default tools"
