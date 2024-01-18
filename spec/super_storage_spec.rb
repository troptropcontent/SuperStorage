# frozen_string_literal: true

RSpec.describe SuperStorage do
  it 'has a version number' do
    expect(SuperStorage::VERSION).not_to be nil
  end

  describe '.register_uploader' do
    context 'when the uploader is valid' do
      after { described_class.reset_registered_uploaders! }
      it 'registers the uploader' do
        expect(described_class.registered_uploaders).to be_empty
        described_class.register_uploader :disk
        expect(described_class.registered_uploaders).to eq([SuperStorage::Uploaders::Disk])
      end
    end
    context 'when the uploader is invalid' do
      it 'raises a LoadError error' do
        expect do
          described_class.register_uploader :invalid
        end.to raise_error(LoadError)
      end
    end
  end

  describe '.registered_uploaders' do
    before { described_class.register_uploader :disk }
    after { described_class.reset_registered_uploaders! }
    it 'returns the registered uploaders' do
      expect(described_class.registered_uploaders).to eq([SuperStorage::Uploaders::Disk])
    end
  end

  describe '.reset_registered_uploaders!' do
    before { described_class.register_uploader :disk }
    it 'resets the registered uploaders' do
      described_class.reset_registered_uploaders!
      expect(described_class.registered_uploaders).to be_empty
    end
  end

  describe '.new' do
    context 'when the uploader is valid' do
      before { described_class.register_uploader :disk }
      after { described_class.reset_registered_uploaders! }
      it 'returns an instance of the uploader' do
        expect(described_class.new(uploader: :disk, configuration: {})).to be_a(SuperStorage::Uploaders::Disk)
      end
    end
    context 'when the uploader is invalid' do
      it 'raises a NameError error' do
        expect do
          described_class.new(uploader: :invalid, configuration: {})
        end.to raise_error(NameError)
      end
    end
  end
end
