require 'spec_helper'

describe 'nodejs::nodenv::plugin' do
  let(:facts) { default_test_facts }

  let(:title) { 'nodenv-vars' }

  let(:default_params) do
    {
      :ensure => 'v1.2.0',
      :source => 'nodenv/nodenv-vars'
    }
  end

  let(:params) { default_params }

  context "ensure => present" do
    it do
      should contain_class('nodejs')
      should contain_file('/test/boxen/nodenv/plugins')
      should contain_repository('/test/boxen/nodenv/plugins/nodenv-vars')
    end
  end

  context "ensure => absent" do
    let(:params) { default_params.merge(:ensure => 'absent') }
    it do
      should contain_repository('/test/boxen/nodenv/plugins/nodenv-vars').with_ensure('absent')
    end
  end
end
