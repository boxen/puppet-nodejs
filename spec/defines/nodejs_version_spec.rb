require 'spec_helper'

describe 'nodejs::version' do
  let(:facts) { default_test_facts }
  let(:title) { '0.10.36' }

  context "ensure => present" do
    context "default params" do
      it do
        should contain_class('nodejs')

        should contain_nodejs('0.10.36').with({
          :ensure     => "installed",
          :node_build => "/test/boxen/node-build/bin/node-build",
          :provider   => 'nodebuild',
          :user       => 'testuser',
        })
      end
    end

    context "when env is default" do
      it do
        should contain_nodejs('0.10.36').with_environment({
          "CC" => "/usr/bin/cc",
          "FROM_HIERA" => "true",
        })
      end
    end

    context "when env is not nil" do
      let(:params) do
        {
          :env => {'SOME_VAR' => "flocka"}
        }
      end

      it do
        should contain_nodejs('0.10.36').with_environment({
          "CC" => "/usr/bin/cc",
          "FROM_HIERA" => "true",
          "SOME_VAR" => "flocka"
        })
      end
    end
  end

  context "ensure => absent" do
    let(:params) do
      {
        :ensure => 'absent'
      }
    end

    it do
      should contain_nodejs('0.10.36').with_ensure('absent')
    end
  end
end
