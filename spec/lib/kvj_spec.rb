require_relative '../../lib/kvj'

describe KVJ do
  before { allow_any_instance_of(FileConnector).to receive(:create_file) }
  before { allow(File).to receive(:open) }
  describe '.connect' do
    it 'reader base_directory from config/kvj_config' do
      expect(YAML).to receive(:load_file).with('config/kvj_config.yml').and_return('base_directory' => 'base_directory/')
      KVJ.connect('some_database')
    end

    it 'intiate a file FileConnector' do
      allow(YAML).to receive(:load_file).and_return('base_directory' => 'base_directory/')
      expect(KVJ.connect('some_database').instance_variable_get(:@file_connector)).to be_an_instance_of(FileConnector)
    end
  end

  context 'IO' do
    subject { KVJ.new('some_database') }
    before { allow(YAML).to receive(:load_file).with('config/kvj_config.yml').and_return('base_directory' => 'base_directory/') }
    shared_examples_for 'write action' do
      it 'realse lock in the end' do
        expect_any_instance_of(FileConnector).to receive(:release_lock)
      end

      it 'acquire ex lock' do
        expect_any_instance_of(FileConnector).to receive(:grab_ex_lock)
      end
    end

    shared_examples_for 'read action' do
      it 'realse lock in the end' do
        expect_any_instance_of(FileConnector).to receive(:release_lock)
      end

      it 'acquire ex lock' do
        expect_any_instance_of(FileConnector).to receive(:grab_sh_lock)
      end
    end

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

      it 'on inspect keys' do
        expect_any_instance_of(FileConnector).to receive(:grab_sh_lock)
        expect_any_instance_of(FileConnector).to receive(:release_lock)
        subject.inspect_keys
      end
    end
  end
end
