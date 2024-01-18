# typed: true
# frozen_string_literal: true

require 'sorbet-runtime'
require_relative "super_storage/version"

module SuperStorage
  class Error < StandardError; end

  def self.register_uploader(registered_uploaders_name)
    require_relative "super_storage/uploaders/#{registered_uploaders_name}"
    registered_uploaders_class = const_get("SuperStorage::Uploaders::#{registered_uploaders_name.to_s.capitalize}")
    registered_uploaders << registered_uploaders_class
  end

  def self.registered_uploaders
    @registered_uploaders ||= []
  end

  def self.reset_registered_uploaders!
    @registered_uploaders = []
  end

  def self.new(uploader: , configuration: )
    registered_uploaders_class = const_get("SuperStorage::Uploaders::#{uploader.to_s.capitalize}")
    registered_uploaders_class.new(configuration:)
  end
end
