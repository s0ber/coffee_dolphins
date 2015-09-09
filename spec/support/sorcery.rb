RSpec.configure do |config|
  config.include Sorcery::TestHelpers::Rails::Controller, type: :controller
end
