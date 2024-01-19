# frozen_string_literal: true

require 'super_storage'
require 'byebug'

def file_path(*)
  File.expand_path(File.join(File.dirname(__FILE__), 'fixtures', *))
end

def test_folder(*)
  File.expand_path(File.join(File.dirname(__FILE__), 'test', *))
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
