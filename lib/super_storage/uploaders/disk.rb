# typed: true
# frozen_string_literal: true

module SuperStorage
  module Uploaders
    # This class is responsible for storing files to disk.
    class Disk
      extend T::Sig
      attr_reader :configuration, :root, :path

      sig { params(configuration: T::Hash[Symbol, T.untyped]).void }
      def initialize(configuration:)
        @root = configuration[:root] || Dir.pwd
        @path = configuration[:path] || 'storage'
        @configuration = configuration.except(:root, :path)
      end

      sig { params(file: T.any(String, File)).void }
      def store!(file)
        destination_path = ::File.expand_path(path, root)
        ::FileUtils.mkdir_p(destination_path)
        ::FileUtils.cp(file, destination_path)
      end

      sig { params(identifier: String).returns(File) }
      def retrieve!(identifier)
        ::File.open(::File.expand_path(identifier, path))
      end
    end
  end
end
