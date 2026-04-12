class GeminiService
  class << self
    attr_accessor :responses, :captured_prompts

    def setup
      @responses = []
      @captured_prompts = []
    end

    def push_response(type:, content:)
      # type is ignored here as the real service just returns a string
      # but we'll use it to format the response if needed
      @responses << content
    end
  end

  def generate_response(conversation, user)
    # Capture context for verification
    self.class.captured_prompts << {
      conversation: conversation,
      user: user,
      context: { stack_list: user.stack_names.join(", ") }
    }

    self.class.responses.shift || "What is your primary goal?"
  end
end
