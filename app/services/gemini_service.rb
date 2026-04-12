require "net/http"
require "json"

class GeminiService
  API_ENDPOINT = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent".freeze

  def initialize
    @api_key = ENV["GEMINI_API_KEY"]
  end

  def generate_response(conversation, user)
    uri = URI("#{API_ENDPOINT}?key=#{@api_key}")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request.body = build_request_body(conversation, user).to_json

    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      parse_response(response.body)
    else
      Rails.logger.error "Gemini API error: #{response.body}"
      "I'm having trouble connecting right now. Please try again in a moment."
    end
  end

  private

  def build_request_body(conversation, user)
    {
      contents: [
        {
          role: "user",
          parts: [ { text: system_prompt(user) } ]
        },
        *format_conversation_history(conversation)
      ],
      generationConfig: {
        temperature: 0.7,
        maxOutputTokens: 1024
      }
    }
  end

  def system_prompt(user)
    stack_list = user.stack_names.join(", ").presence || "No tools in stack yet"

    <<~PROMPT
      You are Nook, an expert app/tool discovery assistant with a friendly, conversational tone.

      Your job:
      1. Ask 1-3 clarifying questions to understand the user's exact needs
      2. Recommend exactly 3 specific apps/tools that solve their problem
      3. Consider their existing stack when making recommendations

      User's current stack: #{stack_list}

      Rules:
      - Be conversational and friendly, like chatting with a knowledgeable friend
      - Ask follow-ups before recommending (but no more than 3 questions total)
      - When recommending, format each recommendation like this:
        1. **App Name** - Brief description (Platform) - Pricing
      - Mention how recommendations integrate with tools in their stack
      - Don't ask more than 3 questions before giving recommendations
      - If they've answered enough questions, give 3 recommendations

      Pricing options: Free, Freemium, Paid
      Platforms: iOS, Android, Web, Mac, Windows, Linux, Chrome Extension
    PROMPT
  end

  def format_conversation_history(conversation)
    conversation.messages.order(:created_at).last(10).map do |message|
      {
        role: message.user? ? "user" : "model",
        parts: [ { text: message.content } ]
      }
    end
  end

  def parse_response(body)
    data = JSON.parse(body)

    if data["candidates"] && data["candidates"].first["content"]
      data["candidates"].first["content"]["parts"].first["text"]
    else
      "I'm not sure about that. Could you tell me more about what you're looking for?"
    end
  rescue JSON::ParserError => e
    Rails.logger.error "Failed to parse Gemini response: #{e.message}"
    "I'm having trouble understanding. Could you rephrase that?"
  end
end
