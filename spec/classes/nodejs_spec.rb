require "spec_helper"

describe "nodejs" do
  let(:facts) { default_test_facts }

  let(:default_params) do
    {
      :provider => "nodenv",
      :prefix   => "/test/boxen",
    }
  end

  let(:params) { default_params }

  it { should contain_class("nodejs::build") }
  it { should contain_file("/opt/nodes") }

  context "provider is nodenv" do
    let(:params) {
      default_params.merge(:provider => "nodenv")
    }

    it { should contain_class("nodejs::nodenv") }
  end

  context "osfamily is Darwin" do
    let(:facts) {
      default_test_facts.merge(:osfamily => "Darwin")
    }

    it { should contain_class("boxen::config") }
    it { should contain_boxen__env_script("nodejs") }

    it do
      should contain_file("/opt/nodes").with({
        :ensure => "directory",
        :owner  => "testuser",
      })
    end
  end

  context "osfamily is not Darwin" do
    let(:facts) {
      default_test_facts.merge(:osfamily => "Linux", :id => "root")
    }

    it { should_not contain_class("boxen::config") }
    it { should_not contain_boxen__env_script("nodejs") }

    it do
      should contain_file("/opt/nodes").with({
        :ensure => "directory",
        :owner  => "root",
      })
    end
  end
end
