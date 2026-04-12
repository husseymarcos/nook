Pay.setup do |config|
  config.enabled_processors = %i[lemon_squeezy]
  config.automount_routes = true
  config.routes_path = "/pay"
end
