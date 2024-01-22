# frozen_string_literal: true

require 'super_storage/uploaders/disk'

module SuperStorage
  module Uploaders
    RSpec.describe Disk do
      describe '#store!' do
        let(:test_file_path) { file_path('test.txt') }
        after { FileUtils.rm_rf(test_folder) }
        context 'when file is a File' do
          let(:file) { UploadedFile.new(file_name: 'test.txt', file: File.open(test_file_path)) }
          it 'stores file to disk  and returns its identifier' do
            result = described_class.new(configuration: { path: 'spec/test' }).store!(file)
            expect(result).to eq('spec/test/test.txt')
            expect(File).to exist('spec/test/test.txt')
          end
        end
        context 'when file is a String' do
          let(:file) { UploadedFile.new(file_name: 'test.txt', file: test_file_path) }
          it 'stores file to disk  and returns its identifier' do
            result = described_class.new(configuration: { path: 'spec/test' }).store!(file)
            expect(result).to eq('spec/test/test.txt')
            expect(File).to exist('spec/test/test.txt')
          end
        end
      end

      describe '#retrieve!' do
        context 'when file exists' do
          before { FileUtils.mkdir_p(test_folder) && FileUtils.cp(file_path('test.txt'), test_folder('test.txt')) }
          after { FileUtils.rm_rf(test_folder) }
          it 'returns file' do
            file = described_class.new(configuration: { path: 'spec/test' }).retrieve!('spec/test/test.txt')
            expect(file).to be_a(File)
          end
        end
        context 'when file does not exist' do
          it 'raises error' do
            expect do
              described_class.new(configuration: { path: 'spec/test' }).retrieve!('test.txt')
            end.to raise_error(Errno::ENOENT)
          end
        end
      end
    end
  end
end
