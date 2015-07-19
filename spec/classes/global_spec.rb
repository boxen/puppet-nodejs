require 'spec_helper'

describe 'nodejs::global' do
  let(:facts) { default_test_facts }

  context 'system node' do
    let(:params) { {:version => 'system'} }

    it do
      should contain_file('/test/boxen/nodenv/version')
    end
  end

  context 'non-system node' do
    let(:params) { {:version => '0.10.36'} }

    it do
      should contain_file('/test/boxen/nodenv/version').that_requires('Nodejs::Version[0.10.36]')
    end
  end
end
