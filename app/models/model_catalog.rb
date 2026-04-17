class ModelCatalog
  FREE_GEMINI_PATTERN = /gemini-\d+\.\d+-flash/

  class << self
    def available_chat_models
      RubyLLM.models.chat_models.all
             .select { |model| free_gemini?(model) }
             .sort_by { |model| [ model.provider.to_s, model.name.to_s ] }
    end

    private
      def free_gemini?(model)
        model.provider.to_s == "gemini" && model.id.to_s.match?(FREE_GEMINI_PATTERN)
      end
  end
end
