require_relative '../../lib/kvj'

describe KVJ do
  before { allow_any_instance_of(FileConnector).to receive(:create_file) }
  before { allow(File).to receive(:open) }

  describe '.connect' do
    it 'intiate a file FileConnector' do
      allow(YAML).to receive(:load_file).and_return('base_directory' => 'base_directory/')
      expect(KVJ.connect('some_database').instance_variable_get(:@database)).to eq('some_database')
      expect(KVJ.connect('some_database').instance_variable_get(:@file_connector)).to be_an_instance_of(FileConnector)
    end
  end

  context 'IO' do
    subject { KVJ.connect('some_database') }
    before { allow(YAML).to receive(:load_file).with('config/kvj_config.yml').and_return('base_directory' => 'base_directory/') }
    context 'grab and relase the lock' do
      before { allow_any_instance_of(FileConnector).to receive(:read).and_return('key' => 'value') }
      it 'on []' do
        expect_any_instance_of(FileConnector).to receive(:grab_sh_lock)
        expect_any_instance_of(FileConnector).to receive(:release_lock)
        subject['key']
      end

      it 'on []=' do
        expect_any_instance_of(FileConnector).to receive(:grab_ex_lock)
        expect_any_instance_of(FileConnector).to receive(:release_lock)
        subject['key'] = 'Value'
      end

      it 'delete key' do
        expect_any_instance_of(FileConnector).to receive(:grab_ex_lock)
        expect_any_instance_of(FileConnector).to receive(:release_lock)
        subject.delete('key')
      end
    end
  end
end
