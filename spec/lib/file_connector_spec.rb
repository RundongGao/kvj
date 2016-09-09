require_relative '../../lib/file_connector'

describe FileConnector do
  before { allow_any_instance_of(FileConnector).to receive(:create_file) }
  before { allow(File).to receive(:open) }
  describe '.new' do
    context 'given file name' do
      it 'sets file_path to file name' do
        path = FileConnector.new('some_file_name').instance_variable_get(:@file_path)
        expect(path).to eql('data/some_file_name.json')
      end
    end

    context 'given file name and file directory' do
      it 'sets file_path to file name' do
        path = FileConnector.new('some_file_name', 'some_direct').instance_variable_get(:@file_path)
        expect(path).to eql('some_direct/some_file_name.json')
      end
    end

    context 'file does not exist' do
      it 'create folder and file' do
        expect_any_instance_of(FileConnector).to receive(:create_file)
        FileConnector.new('some_file_name', 'some_direct')
      end
    end
  end

  context 'read and write' do
    subject { FileConnector.new('some_file_name', 'some_direct') }
    before { allow(subject).to receive(:if_exist).and_return(true) }
    describe '.read' do
      it 'reads @file_path file' do
        allow(JSON).to receive(:parse)
        expect(File).to receive(:read).with('some_direct/some_file_name.json')
        subject.read
      end

      it 'returns a hash of json file' do
        allow(File).to receive(:read).and_return('a hash')
        expect(JSON).to receive(:parse).with('a hash')
        subject.read
      end
    end

    describe '.write' do
      it 'opens to file' do
        allow(subject).to receive(:read)
        expect(File).to receive(:open).with('some_direct/some_file_name.json', 'w')
        subject.write('a hash')
      end

      it 'opens to file' do
        allow(subject).to receive(:read)
        expect(File).to receive(:open).with('some_direct/some_file_name.json', 'w')
        subject.write('a hash')
      end

      it 'returns the current value' do
        allow(File).to receive(:open)
        expect(subject).to receive(:read)
        subject.write('a hash')
      end
    end
  end
end
