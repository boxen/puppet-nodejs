require 'spec_helper'

describe 'nodejs::alias' do
  let(:facts) { default_test_facts }

  let(:title) { '0.10' }

  let(:default_params) { {
    :to => '0.10.36',
    :ensure => 'installed'
  } }

  let(:params) { default_params }

  it do
    should contain_nodejs('0.10.36')
    should contain_file('/opt/nodes/0.10').with({
      :ensure => 'symlink',
      :force  => true,
      :target => '/opt/nodes/0.10.36'
    }).that_requires('Nodejs::Version[0.10.36]')
  end

  context "ensure => absent" do
    let(:params) { default_params.merge(:ensure => 'absent') }
    it do
      should_not contain_nodejs('0.10.36')
      should contain_file('/opt/nodes/0.10').with_ensure('absent')
    end
  end
end
