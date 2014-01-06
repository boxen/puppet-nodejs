require 'spec_helper'

describe 'nodejs::plugin' do
  let(:facts) { default_test_facts }

  let(:title) { 'nodenv-vars' }

  let(:params) do
    { :ensure => 'present', :source => 'johnbellone/nodenv-vars' }
  end

  it do
    should include_class('nodejs')

    should contain_repository('/test/boxen/nodenv/plugins/nodenv-vars').with({
      :ensure => 'present',
      :source => 'johnbellone/nodenv-vars'
    })
  end
end
