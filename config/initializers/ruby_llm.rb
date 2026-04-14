RubyLLM.configure do |config|
  config.gemini_api_key = Rails.application.credentials.dig(:gemini, :api_key) || "test_gemini_key"
  config.default_model = "gemini-2.5-flash"
  config.use_new_acts_as = true
end
