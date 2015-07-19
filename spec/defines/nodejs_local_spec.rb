require 'spec_helper'

describe 'nodejs::local' do
  let(:facts) do
    {
      :boxen_home                  => '/opt/boxen',
      :boxen_user                  => 'wfarr',
      :macosx_productversion_major => '10.10'
    }
  end

  let(:title) { '/tmp' }

  context 'ensure => present' do
    let(:params) do
      {
        :version => '0.10.36'
      }
    end

    it do
      should contain_nodejs__version('0.10.36')

      should contain_file('/tmp/.nodenv-version').with_ensure('absent')
      should contain_file('/tmp/.node-version').with({
        :ensure  => 'present',
        :content => "0.10.36\n",
        :replace => true
      })
    end
  end

  context 'ensure => absent' do
    let(:params) do
      {
        :ensure => 'absent',
      }
    end

    it do
      should contain_file('/tmp/.nodenv-version').with_ensure('absent')
      should contain_file('/tmp/.node-version').with_ensure('absent')
    end
  end
end
