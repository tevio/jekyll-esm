require "bundler/setup"
require "jekyll/esm"

RSpec.configure do |config|
  FIXTURES_DIR = File.expand_path("fixtures", __dir__)
  def fixtures_dir(*paths)
    File.join(FIXTURES_DIR, *paths)
  end

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
