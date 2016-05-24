require "spec_helper"

describe "nodejs::nodenv" do
  let(:facts) { default_test_facts }

  let(:default_params) do
    {
      :ensure   => 'v0.4.0',
      :prefix   => '/test/boxen/nodenv',
      :user     => 'testuser',
      :plugins  => {}
    }
  end

  let(:params) { default_params }

  context "ensure => present" do
    context "default params" do
      it do
        should contain_class('nodejs')

        should contain_repository('/test/boxen/nodenv').with({
          :ensure => 'v0.4.0',
          :force  => true,
          :source => 'nodenv/nodenv',
          :user   => 'testuser'
        })

        should contain_file('/test/boxen/nodenv/versions').with({
          :ensure  => 'symlink',
          :force   => true,
          :backup  => false,
          :target  => '/opt/nodes'
        }).that_requires('Repository[/test/boxen/nodenv]')
      end
    end

    context "when plugins is default or empty" do
      it do
        should_not contain_file('/test/boxen/nodenv/plugins')
        should_not contain_nodejs__nodenv__plugin('nodenv-vars')
      end
    end

    context "when plugins is not empty" do
      let(:params) { default_params.merge(:plugins => { 'nodenv-vars' => { 'ensure' => 'v1.2.0', 'source' => 'nodenv/nodenv-vars' } } ) }

      it do
        should contain_file('/test/boxen/nodenv/plugins')
        should contain_nodejs__nodenv__plugin('nodenv-vars').with({
          :ensure => 'v1.2.0',
          :source => 'nodenv/nodenv-vars'
        })
      end
    end
  end

  context "ensure => absent" do
    let(:params) { default_params.merge(:ensure => 'absent', :plugins => { 'nodenv-vars' => { 'ensure' => 'v1.2.0', 'source' => 'nodenv/nodenv-vars' } } ) }

    it do
      should contain_repository('/test/boxen/nodenv').with_ensure('absent')
      should_not contain_file('/test/boxen/nodenv/plugins')
      should_not contain_nodejs__nodenv__plugin('nodenv-vars')
    end
  end
end
