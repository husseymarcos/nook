class GeminiService
  class << self
    attr_accessor :responses, :captured_prompts

    def setup
      @responses = []
      @captured_prompts = []
    end

    def push_response(type:, content:)
      @responses << content
    end
  end

  def generate_response(conversation, user)
    self.class.captured_prompts << {
      conversation: conversation,
      user: user,
      context: { stack_list: user.all_tool_names.join(", ") }
    }

    self.class.responses.shift || "What is your primary goal?"
  end
end
