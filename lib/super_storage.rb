# typed: true
# frozen_string_literal: true

require 'sorbet-runtime'
require_relative 'super_storage/version'

# This module is the main entry point of the gem.
module SuperStorage
  class Error < StandardError; end

  extend T::Sig

  sig { params(registered_uploaders_name: Symbol).void }
  def self.register_uploader(registered_uploaders_name)
    require_relative "super_storage/uploaders/#{registered_uploaders_name}"
    registered_uploaders_class = const_get("SuperStorage::Uploaders::#{registered_uploaders_name.to_s.capitalize}")
    registered_uploaders << registered_uploaders_class
  end

  sig { returns(T::Array[T.class_of(SuperStorage::Uploaders::Disk)]) }
  def self.registered_uploaders
    @registered_uploaders ||= []
  end

  sig { void }
  def self.reset_registered_uploaders!
    @registered_uploaders = []
  end

  sig { params(uploader: Symbol, configuration: T::Hash[Symbol, T.untyped]).returns(SuperStorage::Uploaders::Disk) }
  def self.new(uploader:, configuration:)
    registered_uploaders_class = const_get("SuperStorage::Uploaders::#{uploader.to_s.capitalize}")
    registered_uploaders_class.new(configuration:)
  end
end
