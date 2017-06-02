# frozen_string_literal: true

RSpec.configure do |config|
  config.profile_examples = 10
  config.order = :random
  Kernel.srand config.seed
end
