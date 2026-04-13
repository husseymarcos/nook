RubyLLM.configure do |config|
  config.gemini_api_key = ENV.fetch("GEMINI_API_KEY", Rails.application.credentials.dig(:gemini_api_key))
  config.default_model = "gemini-2.5-flash"
  config.use_new_acts_as = true
end
