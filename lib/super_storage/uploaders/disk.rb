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

      sig { params(file: UploadedFile).returns(String) }
      def store!(file)
        destination_path = ::File.expand_path(path, root)
        ::FileUtils.mkdir_p(destination_path)
        ::FileUtils.cp(file.file, destination_path)

        file = file.file
        file_path = file.is_a?(String) ? file : file.path
        ::File.join(path, File.basename(file_path))
      end

      sig { params(identifier: String).returns(File) }
      def retrieve!(identifier)
        ::File.open(::File.expand_path(identifier, root))
      end
    end
  end
end
