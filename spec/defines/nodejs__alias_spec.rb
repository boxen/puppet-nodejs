require 'spec_helper'

describe 'nodejs::alias' do
  let(:facts) { default_test_facts }

  let(:title) { 'v0.10' }

  let(:default_params) { {
    :to => 'v0.10.29',
    :ensure => 'installed'
  } }

  let(:params) { default_params }

  it do
    should contain_nodejs('v0.10.29')
    should contain_file("/test/boxen/nodenv/versions/v0.10").with({
      :ensure => "symlink",
      :force  => true,
      :target => "/test/boxen/nodenv/versions/v0.10.29"
    }).that_requires('Nodejs::Version[v0.10.29]')
  end

  context "ensure => absent" do
    let(:params) { default_params.merge(:ensure => 'absent') }
    it do
      should_not contain_nodejs('v0.10.29')
      should contain_file('/test/boxen/nodenv/versions/v0.10').with_ensure('absent')
    end
  end
end
